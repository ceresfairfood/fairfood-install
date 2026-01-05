# Switching servers

Move servers step by step.
Most steps are reversible, but not all (switching databases).

## Long term preparation

- [ ] Change DNS TTL to 5 minutes in Rackspace DNS.
- [ ] Create new server and add new DNS record.
- [ ] Also add new server IP to SPF record.

## Prepare

- [ ] Forward TLS certificate challenges from the old to the new server. On the old server, edit `/etc/nginx/letsencrypt-webrootauth.inc`:
  ```
  # For certbot automatic renewal
  location '/.well-known/acme-challenge' {
    default_type "text/plain";
    # root /etc/letsencrypt/webrootauth;
    proxy_pass http://43.239.97.114;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }
  ```
- [ ] Add new server to Ansible hosts with jobs disabled.
- [ ] Provision server with Ansible scripts: `ansible-playbook -l prod4.ceresfairfood.org.au -u root site.yml`
- [ ] Set up firewall for general security.
  ```
  apt install ufw
  ufw allow ssh
  ufw allow http
  ufw allow https
  ufw default deny incoming
  ufw default allow outgoing
  ufw enable
  ```
- [ ] Copy DKIM key to `/etc/opendkim/keys/mail.private`.
- [ ] Check timezone on new server
- [ ] Push code to new server:
  ```
  git push fairfood@prod4.ceresfairfood.org.au:~/current
  ```
- [ ] Copy uploaded files to new server:
  ```
  # ssh -A fairfood@prod4.ceresfairfood.org.au
  scp -r fairfood@prod3.ceresfairfood.org.au:current/public/images/label_icons databases.sql.gz current/public/images
  ```
- [ ] PRODUCTION: Set up SSH tunnel for database access:
  ```
  # /etc/systemd/system/autossh-mysql-tunnel.service
  #
  # https://www.everythingcli.org/ssh-tunnelling-for-fun-and-profit-autossh/
  [Unit]
  Description=AutoSSH tunnel service to old MySQL on local port 3307
  After=network.target

  [Service]
  User=fairfood
  Environment="AUTOSSH_GATETIME=0"
  ExecStart=/usr/bin/autossh -M 0 -o "ServerAliveInterval=30" -o "ServerAliveCountMax=3" -o "ExitOnForwardFailure=yes" -NL 3307:localhost:3306 fairfood@prod3.ceresfairfood.org.au

  [Install]
  WantedBy=multi-user.target

  ## Ensure enabled after restart
  systemctl daemon-reload
  systemctl enable autossh-mysql-tunnel.service
  systemctl start autossh-mysql-tunnel.service
  ```
- [ ] PRODUCTION: enable database replication from old db to new db
  ```
  # Edit mysql/mariadb config
  # Warning: Debian can have multiple config files and only some are loaded
  # Replace lines in `/etc/mysql/mariadb.conf.d/50-server.cnf`:
  #
  # server-id              = 3 # simply because this is prod3
  # log_bin                = /var/log/mysql/mysql-bin.log
  systemctl restart mariadb.service

  password=$(openssl rand -base64 32)
  mysql -e "CREATE USER 'fairfood_replication'@'%' IDENTIFIED BY '$password';"
  mysql -e "GRANT REPLICATION SLAVE ON *.* TO 'fairfood_replication'@'%';"
  mysqldump --skip-lock-tables --single-transaction --flush-logs --hex-blob --master-data \
    --databases fairfood_production fairfood_wordpress fairfood_wordpress_staging \
    | gzip > /srv/fairfood/databases.sql.gz
  ```
  ```
  # On the slave as root:
  #   ssh -A root@prod4.ceresfairfood.org.au
  #
  # Ensure no accidental app writes, root can still write.
  # This is lost after server restart.
  mysql -e "GLOBAL read_only = 1;"

  scp fairfood@prod3.ceresfairfood.org.au:databases.sql.gz ./
  zcat databases.sql.gz | mysql

  mysql -e "CHANGE MASTER TO
    MASTER_HOST='43.239.97.148',
    MASTER_PORT='3307',
    MASTER_USER='fairfood_replication',
    MASTER_PASSWORD='secret password';
    START SLAVE;
    SLAVE STATUS \G"
  ```
    * Confirm data flowing as expected (eg `select max(updated_at) from fairfood_production.carts;`).
- [ ] Forward some pages for testing on the new server:
  ```
  location '/admin/debug/' {
    proxy_pass https://43.239.97.114;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }
  ```
- [ ] Test email delivery and DKIM/SPF validation from the new server with https://dkimvalidator.com.
  ```rb
  MassMailer.email_single_user(to: "fairfood@dkimvalidator.com", from: EMAIL_INFO, subject: "Test", body: "Hello").deliver_now
  ```
- [ ] Test web application by changing your local `/etc/hosts` file.
- [ ] Deactivate deployments in `/srv/fairfood/current/.git/hooks/post-receive`:
  ```
  # Tell other devs to not deploy to the old server:
  echo "[ERROR] Aborting deploy!"
  echo "Maikel is setting up a new server."
  exit 1
  ```
- [ ] Check new database:
  ```
  mysql -e 'SHOW SLAVE STATUS \G' -e 'select @@server_id, @@global.read_only, @@read_only;' -e 'select max(updated_at) from fairfood_production.carts;'
  ```

## Switch application

- [ ] Deactivate monit for old delayed job: `monit unmonitor fairfood_dj_worker`
- [ ] STAGING: copy database
  ```bash
  # Connect with your SSH key to the new server:
  ssh -A fairfood@prod4.ceresfairfood.org.au

  # Copy the database from the old server:
  ssh -C prod3.ceresfairfood.org.au "mysqldump fairfood_staging" | mysql
  ```
- [ ] Insert BUT NOT RELOAD proxy config into `/etc/nginx/sites-enabled/fairfood_https.conf`:
  ```
    # TEMP: proxy pass all other traffic to new server
    location ~ .* {
      proxy_pass https://43.239.97.114;
      proxy_ssl_name $host;
      proxy_set_header Host $host;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
  ```
- [ ] Shut down the old application:
  ```
  su - fairfood -c "cd current && RAILS_ENV=production ./script/delayed_job stop" &&\
  su - fairfood -c "crontab -r" &&\
  systemctl stop puma-fairfood.service &&\
  mysql -e "SET GLOBAL read_only = 1;" &&\
  systemctl reload nginx.service
  ```
- [ ] On new server:
  ```
  mysql -e "STOP SLAVE; SET GLOBAL read_only = 0;" &&\
  su - fairfood -c "cd current && bundle exec whenever --set environment=production --update-crontab fairfood"
  su - fairfood -c "cd current && RAILS_ENV=production ./script/delayed_job start"
  ```
- [ ] Monitor log files:
  + `tail -f /srv/fairfood/current/log/puma.log`
  + `tail -f /srv/fairfood/current/log/delayed_job.log`
  + `tail -f /srv/fairfood/current/log/cron.stdout.log`
- [ ] Confirm emails are being sent out (check [ceresfairfood-history](https://groups.google.com/a/openfoodnetwork.org.au/g/ceresfairfood-history))
- [ ] Update post-receive hook on new server to install cronjobs.

**Finishing it off:**
- [ ] Disable mysql readonly mode on old server if required (eg Wordpress).
- [ ] Set up Wormly metrics.
```
apt install collectd
scp prod3.ceresfairfood.org.au:/etc/collectd/collectd.conf.d/wormly.conf /etc/collectd/collectd.conf.d/
ssh prod3.ceresfairfood.org.au "systemctl stop collectd.service"
systemctl restart collectd.service
```
- [ ] Check metrics at https://www.wormly.com/jsgraphs/jsgraphpageid/424045.
- [ ] Update post-receive hook on old server:

```
# Tell other devs to deploy to the new server:
echo "[ERROR] Aborting deploy!"
echo "We have a new server."
echo ""
echo "  git remote set-url production fairfood@prod4.ceresfairfood.org.au:~/current"
echo ""
exit 1
```
- [ ] Change DNS entry.
- [ ] Remove old server from SPF record.

## Finally
- [ ] Disable root login.
  ```
  vi /etc/ssh/sshd_config
  # PermitRootLogin no
  ```
- [ ] Disable unused services:
  - [ ] php-fpm
  - [ ] mariadb
  - [ ] nginx
- [ ] Shut down old server.
- [ ] Delete old server.
- [ ] Remove old DNS records.
- [ ] Increase DNS TTL again.
