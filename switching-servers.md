# Switching servers

We experienced a few issues moving to a new server.
Most of them had to do with changes in the underlying OS (Debian).
Moving step by step, minimises the impact of issues.
The following is a list of steps we have done the last time.
Most steps are reversible, but not all (switching databases).
The list is not complete, please do additional sanity checks where possible.

**Long term preparation:**
- [ ] Prepare new server and add new DNS record (eg `prod4.ceresfairfood.org.au`)
- [ ] Also add new server IP to SPF record
- [ ] test mail delivery and DKIM/SPF validation from the new server (eg with https://dkimvalidator.com). Update as needed.
  - It's suggested to use a new DKIM key when upgrading prod. You'll need to copy the key to staging and old prod to ensure they can still send from the same domain.
- [ ] check timezone on new server
- [ ] change DNS TTL to 5 minutes (ensure all DNS services are updated, eg Rimu and Rackspace)
- [ ] Identify any current config that may need to be included (eg cron jobs)
- [ ] set up new rails app to point to db on old server
  - Eg use a service with autossh to set up a persistent ssh tunnel (perhaps simpler than setting up mysql over network which may require restarting mysql)
  ```
  $ vim /etc/systemd/system/autossh-mysql-tunnel.service
  # https://www.everythingcli.org/ssh-tunnelling-for-fun-and-profit-autossh/
  [Unit]
  Description=AutoSSH tunnel service prod2 MySQL on local port 3307
  After=network.target

  [Service]
  User=fairfood
  Environment="AUTOSSH_GATETIME=0"
  ExecStart=/usr/bin/autossh -M 0 -o "ServerAliveInterval=30" -o "ServerAliveCountMax=3" -o "ExitOnForwardFailure=yes" -NL 3307:localhost:3306 members.ceresfairfood.org.au@prod2.ceresfairfood.org.au

  [Install]
  WantedBy=multi-user.target

  ## Ensure enabled after restart
  sudo systemctl daemon-reload
  sudo systemctl enable autossh-mysql-tunnel.service
  sudo systemctl start autossh-mysql-tunnel.service
  ```
  - Requires that user `fairfood` on new server has public key authorised for remote user
  - Confirm connection `mysql -h 127.0.0.1 -P 3307 -u fairfood -p fairfood_production`
  - Update `config/database.yml`
  ```
  # old prod
  password: "secret password"
  host: 127.0.0.1 #force 'local' tcp
  port: 3307 #ssh tunnel to old prod
  ```
- [ ] enable database replication from old db to new db
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
    - confirm data flowing as expected (eg `select max(updated_at) from fairfood_production.users;`)
    - confirm status again after system restart
    - add old server password to .my.cnf on new server. So that script/enqueue can connect to old db temporarily.
    - add IP address to [TXT](https://rimuhosting.com/dns/records.jsp?zone=ceresfairfood.org.au&type=TXT&rid=2) SPF record

**Prepare:**
- [ ] deactivate old git post-receive hook for deployments
  ```
  # Tell other devs to not deploy to the old server:
  echo "[ERROR] Aborting deploy!"
  echo "[Thu 8 Feb 2018] Maikel is about to switch to the new production server."
  exit 1
  ```
- [ ] deploy master to new server (start new application)
  ```
  git remote set-url production fairfood@prod3.ceresfairfood.org.au:~/current
  git push production
  ```
- [ ] test web application
- [ ] Update domain in new nginx config with production domain (eg `vim /etc/nginx/sites-available/fairfood_https.conf`)
  - You may test with a local hosts file (type `thisisunsafe` anywhere on the page in Chrome to bypass cert error)

**Switch delayed jobs:**
- [ ] deactivate monit for old delayed job: `monit unmonitor fairfood_dj_worker`
- [ ] stop old delayed job: `RAILS_ENV=production ./script/delayed_job stop`
- [ ] ensure new delayed job running: `RAILS_ENV=production ./script/delayed_job start`
- [ ] monitor log file: `tail -f /srv/fairfood/current/log/delayed_job.log`
- [ ] update post-receive hook on new server to restart delayed job

**Switch application:**
- [ ] nginx proxy pass from old to new app
  ```
    $ sudo vim /etc/nginx/sites-enabled/fairfood_https.conf

    # TEMP: proxy pass all other traffic to new prod3 server
    location ~ .* {
      proxy_pass https://43.239.97.148;
      proxy_ssl_name $host;
      proxy_set_header Host $host;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    location @unicorn {
    ...
  ```
- [ ] confirm emails are being sent out (check [ceresfairfood-history](https://groups.google.com/a/openfoodnetwork.org.au/g/ceresfairfood-history))
- [ ] deactivate monit for old application `monit unmonitor -g unicorn_workers`
- [ ] shut down the old application

**Switch cron jobs when there is a gap in schedule:**
- [ ] clear cron jobs on old server
  - [ ] immediately install cron jobs on new server `bundle exec whenever --set "environment=production" --update-crontab "fairfood"`
- [ ] update post-receive hook on new server to install cronjobs
- [ ] monitor log file after 5 mins to confirm: `tail -f /srv/fairfood/current/log/cron.stdout.log`

**Expand Letsencrypt cert on new server:**
- [ ] Proxy pass all http (not https) traffic from old to new server (so that letsencrypt can generate cert).
  ```
   #location '/.well-known/acme-challenge' {
     #default_type "text/plain";
     #root /etc/letsencrypt/webrootauth;
   #}

   location / {
     #return 301 https://$server_name$request_uri;
     proxy_pass http://43.239.97.148;
     proxy_set_header Host $host;
     proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
  ```
- [ ] Expand existing certificate to include primary domain: `letsencrypt certonly --webroot -w /etc/letsencrypt/webrootauth -d prod3.ceresfairfood.org.au -d members.ceresfairfood.org.au --expand`

**Switch databases:**
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
- [ ] udpate password in .my.cnf (for script/enqueue)
- [ ] start delayed job

**Finishing it off:**
- [ ] disable mysql readonly mode on old server if required (eg Wordpress)
- [ ] on new server check `monit status`
- [ ] change DNS entry
- [ ] set up Wormly metrics
- [ ] update post-receive hook on old server:

```
# Tell other devs to deploy to the new server:
echo "[ERROR] Aborting deploy!"
echo "[Thu 15 Feb 2018] We have a new production server."
echo ""
echo "  git remote set-url production fairfood@prod3.ceresfairfood.org.au:~/current"
exit 1
```

**Finally:**
- [ ] Increase DNS TTL again
- [ ] Stop and disable SSH tunnel: `autossh-mysql-tunnel.service`
- [ ] When no longer being used, disable nginx & mysql on old server, and shut down.
- [ ] Delete old server
- [ ] Remove old server DNS record and remove from SPF record
