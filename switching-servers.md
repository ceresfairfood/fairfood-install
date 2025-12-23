# Switching servers

Move servers step by step.
Most steps are reversible, but not all (switching databases).

**Long term preparation:**

- [ ] Change DNS TTL to 5 minutes in Rackspace DNS.
- [ ] Create new server and add new DNS record.
- [ ] Also add new server IP to SPF record.

**Prepare:**

- [ ] Forward TLS certificate challenges from the old to the new server. On the old server, edit `/etc/nginx/sites-enabled/fairfood_http.conf`:
  ```
  # For certbot automatic renewal
  location '/.well-known/acme-challenge' {
    default_type "text/plain";
    # root /etc/letsencrypt/webrootauth;
    proxy_pass http://43.239.97.87;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }
  ```
- [ ] Add new server to Ansible hosts with jobs disabled.
- [ ] Provision server with Ansible scripts: `ansible-playbook -l prod4.ceresfairfood.org.au -u root site.yml`
- [ ] Test email delivery and DKIM/SPF validation from the new server (eg with https://dkimvalidator.com). Update as needed.
  - It's suggested to use a new DKIM key when upgrading prod. You'll need to copy the key to staging and old prod to ensure they can still send from the same domain.
- [ ] Check timezone on new server
- [ ] Deactivate old git post-receive hook for deployments
  ```
  # Tell other devs to not deploy to the old server:
  echo "[ERROR] Aborting deploy!"
  echo "Maikel is setting up a new server."
  exit 1
  ```
- [ ] Push code to new server:
  ```
  git push fairfood@prod4.ceresfairfood.org.au:~/current
  ```

**Switch application:**

- [ ] Deactivate monit for old delayed job: `monit unmonitor fairfood_dj_worker`
- [ ] Stop old delayed job: `RAILS_ENV=production ./script/delayed_job stop`
- [ ] STAGING: copy database
  ```bash
  # Connect with your SSH key to the new server:
  ssh -A fairfood@prod4.ceresfairfood.org.au

  # Copy the database from the old server:
  ssh -C prod3.ceresfairfood.org.au "mysqldump fairfood_staging" | mysql
  ```
- [ ] PRODUCTION: enable database replication from old db to new db
  ```
  # On the master:
  mysql> CREATE USER 'fairfood_replication'@'%' IDENTIFIED BY 'secret password';
     >   GRANT ALL PRIVILEGES ON fairfood_production.* TO 'fairfood_replication'@'%';
     >   GRANT REPLICATION SLAVE ON *.* TO 'fairfood_replication'@'%';
  sudo mysqldump -uroot --skip-lock-tables --single-transaction --flush-logs --hex-blob --master-data=2 fairfood_production > /tmp/fairfood_production-for-replication.sql
  # Find out the MASTER_LOG_FILE and MASTER_LOG_POS
  head fairfood_production-for-replication.sql -n80 | grep "MASTER_LOG_FILE" > mysql-position
  gzip fairfood_production-for-replication.sql

  # on the slave
  zcat fairfood_production-for-replication.sql | mysql
  mysql> CHANGE MASTER TO MASTER_HOST='127.0.0.1', MASTER_PORT=3307, MASTER_USER='fairfood_replication', MASTER_PASSWORD='<secret password>', MASTER_LOG_FILE='mysql-bin.000123', MASTER_LOG_POS=366;
     >   START SLAVE;
     >   SHOW SLAVE STATUS \G
     >   SET GLOBAL read_only = 1; --Ensure no accidental writes
  ```
    - Confirm data flowing as expected (eg `select max(updated_at) from fairfood_production.users;`).
    - Confirm status again after system restart.
- [ ] Test web application.






- [ ] Ensure new delayed job running: `RAILS_ENV=production ./script/delayed_job start`
- [ ] Monitor log file: `tail -f /srv/fairfood/current/log/delayed_job.log`

- [ ] Nginx proxy pass from old to new app in `/etc/nginx/sites-enabled/fairfood_https.conf` before any rails blocks:
  ```
    # TEMP: proxy pass all other traffic to new server
    location ~ .* {
      proxy_pass https://43.239.97.87;
      proxy_ssl_name $host;
      proxy_set_header Host $host;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
  ```
- [ ] Shut down the old application: `systemctl stop puma-fairfood.service`
- [ ] Confirm emails are being sent out (check [ceresfairfood-history](https://groups.google.com/a/openfoodnetwork.org.au/g/ceresfairfood-history))

**Switch cron jobs when there is a gap in schedule:**
- [ ] Clear cron jobs on old server: `crontab -r`
  - [ ] Immediately install cron jobs on new server `bundle exec whenever --set "environment=production" --update-crontab "fairfood"`
- [ ] Update post-receive hook on new server to install cronjobs.
- [ ] Monitor log file after 5 mins to confirm: `tail -f /srv/fairfood/current/log/cron.stdout.log`

**PRODUCTION: Switch databases**
- [ ] check databases are in sync
  + `SHOW SLAVE STATUS \G`
  + (eg on both: `mysql -e 'select @@server_id, @@read_only, max(updated_at) from fairfood_production.users;'`)
- [ ] make new mysql db writable `SET GLOBAL read_only = 0;`
- [ ] change new database.yml to point to local db server (confirm password is correct)
- [ ] stop delayed job
- [ ] confirm no other scheduled tasks currently running or about to run
- [ ] Simultaneously:
  + OLD: set master to read-only `SET GLOBAL read_only = 1;` (requires root. note this will affect any other DBs on the server, like Wordpress.)
  + NEW: make new mysql master `STOP SLAVE; SET GLOBAL read_only = 0;` (requires root. turn off readonly again, to be sure)
  + NEW: reload new application `/etc/init.d/unicorn_fairfood reload`
  + Bugsnag will notify of any failed page loads during this period
- [ ] Start delayed job.

**Finishing it off:**
- [ ] Disable mysql readonly mode on old server if required (eg Wordpress).
- [ ] Change DNS entry.
- [ ] Set up Wormly metrics.
- [ ] Update post-receive hook on old server:

```
# Tell other devs to deploy to the new server:
echo "[ERROR] Aborting deploy!"
echo "We have a new server."
echo ""
echo "  git remote set-url production fairfood@prod3.ceresfairfood.org.au:~/current"
echo ""
exit 1
```

**Finally:**
- [ ] Disable root login.
  ```
  vi /etc/ssh/sshd_config
  # PermitRootLogin no
  ```
- [ ] Increase DNS TTL again.
- [ ] Disable unused services:
  - [ ] php-fpm
  - [ ] mariadb
  - [ ] nginx
- [ ] Remove old server from SPF record.
- [ ] Remove old DNS records.
- [ ] Delete old server.
