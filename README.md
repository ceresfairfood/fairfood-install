# fairfood-install

[Ansible](http://docs.ansible.com/ansible/) scripts to install Ceres Fair Food on a server.
This is not intended to be re-run on a production server, as there may be new config changes on the server that aren't yet stored here.

## Requirements

```sh
# On Debian 10 Buster:
sudo apt install ansible vagrant virt-manager
systemctl start libvirtd
```

If virt-manager doesn't work, try virtualbox.
```sh
# On macOS 10.15:
brew install ansible vagrant virtualbox
# Also for first-time setup, you'll need sshpass to enter the root password:
brew install hudochenkov/sshpass/sshpass # 3rd party tap, check before using. Remove after using.
```

Add your public key to the repo to automatically set up authorised users, eg:

    cat ~/.ssh/id_rsa.pub >> files/admin-ssh-keys/$USER.pub

## Test it locally

First, update the initial schema file (files/fairfood_schema.sql). You can generate it from a dev environment or server 
environment. This will be loaded only the first time you run ansible on the server.

```sh
vagrant up
ansible-playbook -i hosts -l vagrant site.yml

# Login to debug:
vagrant ssh

# You may need to manually install the db client:
# sudo apt-get install libmariadb-dev
```

Tips for testing individual changes:
 * Go straight to specific task: `--start-at-task='<name of task>'`
 * Run one at a time: `--step`

 Eg: `ansible-playbook -i hosts -l vagrant-virtualbox site.yml --step --start-at-task='Install configuration files'`

### Git Push
To test the post-receive script, you can push from your local environment.

```
cd fairfood/
git remote add vagrant ssh://fairfood@localhost:2222/srv/fairfood/current

git push vagrant
```

## Community Roles

Some community roles have been added to the project with:

```sh
ansible-galaxy install -p roles -r requirements.yml
```

## Linting

After you changed code, it's nice to see if it's aligned with standards:
```sh
# pip install ansible-lint
ansible-lint site.yml
```

## Setting up a new server

1. Add the new server to the `hosts` file.
2. Optionally add public key(s) to `files/admin-ssh-keys`
3. Run playbook: `ansible-playbook -i hosts -l staging2.ceresfairfood.org.au site.yml -u root --ask-pass` # root user password defaults to Rimu login
  - If mysql isn't working, ensure it really did install: `sudo apt-get install libmariadb-dev`
4. Push codebase and install app: `git push staging` (this must be done before loading data dump, to ensure any recently deleted tables are removed.)
5. Load database, eg: 
```
ssh fairfood@staging2.ceresfairfood.org.au -A
$ ssh staging.ceresfairfood.org.au "mysqldump -u root fairfood_production | gzip" > old_server.sql.gz
$ zcat old_server.sql.gz | mysql fairfood_production
```

If DNS is not pointing to this server yet, update it and obtain new certificate:
```
ssh root@staging2.ceresfairfood.org.au
$ # Add server name to nginx config.
$ certbot -d staging2.ceresfairfood.org.au -d staging.ceresfairfood.org.au --expand --renew-hook 'systemctl reload nginx'
```

Finally, **remember to disable root login.**
```
sudo vim /etc/ssh/sshd_config
# PermitRootLogin no
```

## Repeatable tasks

Most tasks are not designed to be repeated.

The [add-users](files/admin-ssh-keys/README.md) playbook can be used to add new users.

When running tasks as your own user, you need to include `--ask-become-pass` and provide your password.

## Installing Metabase

Using https://galaxy.ansible.com/libre_ops/metabase
You can refer to defaults: https://github.com/libre-ops/metabase/blob/master/defaults/main.yml

Choose the latest version of Metabase by setting the variable in `all.yml`. 

Use `metabase.yml` playbook, eg:
```sh
ansible-playbook metabase.yml -i hosts -l staging2.ceresfairfood.org.au --ask-become-pass --user <remote-user>
```

Default login is example@example.com / metabase123

Copy existing config database from another installation (eg from `/home/metabase/metabase.db.*`). Or config from scratch, including:

1. Add MySQL database fairfood_metabase, user metabase, password (see `credentials/*/mysqlpassword`)
2. Setup email to use localhost port 25, from metabase@metabase.ceresfairfood.org.au

## Switching servers

We experienced a few issues moving to a new server.
Most of them had to do with changes in the underlying OS (Debian).
Moving step by step, minimises the impact of issues.
The following is a list of steps we have done the last time.
Most steps are reversible, but not all (switching databases).
The list is not complete, please do additional sanity checks where possible.

Long term preparation:
- [ ] test mail delivery from the new server
- [ ] check timezone on new server
- [ ] change DNS TTL to 5 minutes
- [ ] set up new rails app to point to db on old server
  - Eg use a service with autossh to set up a persistent ssh tunnel (perhaps simpler than setting up mysql over network)
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

Prepare:
- [ ] deactivate old git post-receive hook for deployments
  ```
  # Tell other devs to not deploy to the old server:
  echo "[ERROR] Aborting deploy!"
  echo "[Thu 8 Feb 2018] Maikel is about to switch to the new production server."
  exit 1
  ```
- [ ] deploy master to new server (start new application)
- [ ] test web application
- [ ] Update domain in new nginx config with production domain (eg `vim /etc/nginx/sites-available/fairfood_https.conf`)
  - You may test with a local hosts file (type `thisisunsafe` anywhere on the page in Chrome to bypass cert error)

Switch delayed jobs:
- [ ] deactivate monit for old delayed job
- [ ] stop old delayed job: `RAILS_ENV=production ./script/delayed_job stop`
- [ ] ensure new delayed job running: `RAILS_ENV=production ./script/delayed_job start`
- [ ] monitor log file: `tail -f /srv/fairfood/current/log/delayed_job.log`
- [ ] update post-receive hook on new server to restart delayed job

Switch application:
- [ ] nginx proxy pass from old to new app
- [ ] deactivate monit for old application
- [ ] shut down the old application

Switch cron jobs when there is a gap in schedule:
- [ ] clear cron jobs on old server
  - [ ] immediately install cron jobs on new server
- [ ] update post-receive hook on new server to install cronjobs

Expand Letsencrypt cert on new server:
- [ ] Proxy pass http (not https) traffic from old to new server (so that letstencrypt can generate cert)
- [ ] `/usr/local/share/letsencrypt/env/bin/letsencrypt certonly -w /etc/letsencrypt/webrootauth/ -d prod2.ceresfairfood.org.au -d members.ceresfairfood.org.au --expand`

Switch databases:
- [ ] check databases are in sync (eg check your user updated_at after visiting a page)
- [ ] make new mysql db writable
- [ ] change new database.yml to point to local db server
- [ ] stop delayed job
- [ ] confirm no other scheduled tasks currently running or about to run
- [ ] Set old master to read-only
- [ ] reload new application
- [ ] make new mysql master `STOP SLAVE; RESET MASTER;`
- [ ] start delayed job

Finishing it off:
- [ ] on new server check `monit status`
- [ ] change DNS entry
- [ ] copy TLS certificates
- [ ] update post-receive hook on old server:

```
# Tell other devs to deploy to the new server:
echo "[ERROR] Aborting deploy!"
echo "[Thu 15 Feb 2018] We have a new production server."
echo ""
echo "  git remote set-url production fairfood@prod3.ceresfairfood.org.au:~/current"
exit 1
```

Finally:
- [ ] Increase DNS TTL again
- [ ] When no longer being used, shut down old server
- [ ] Delete old server
