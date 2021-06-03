# fairfood-install

[Ansible](http://docs.ansible.com/ansible/) scripts to install Ceres Fair Food on a server.
This is not intended to be re-run on a production server, as there may be new config changes on the server that aren't yet stored here.

## Requirements

```sh
# On Debian 10 Buster:
sudo apt install ansible vagrant virt-manager
systemctl start libvirtd
```

## Test it locally

```sh
vagrant up
ansible-playbook -i hosts -l vagrant site.yml

# Login to debug:
vagrant ssh
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

## Setting up a new staging server

Add the new server to the `hosts` file. Then run:

```
ansible-playbook -i hosts -l staging2.ceresfairfood.org.au site.yml -u root
ssh members.ceresfairfood.org.au@staging2.ceresfairfood.org.au -A
$ ssh staging.ceresfairfood.org.au "mysqldump -u root fairfood_production | gzip" > old_server.sql.gz
$ zcat old_server.sql.gz | mysql fairfood_production

# Update the domain, then:
ssh root@staging2.ceresfairfood.org.au
$ # Add server name to nginx config.
$ certbot -d staging2.ceresfairfood.org.au -d staging.ceresfairfood.org.au --expand --renew-hook 'systemctl reload nginx'

# Disable root login.
```

## Installing Metabase

Using https://galaxy.ansible.com/libre_ops/metabase
You can refer to defaults: https://github.com/libre-ops/metabase/blob/master/defaults/main.yml

Choose the latest version of Metabase by setting the variable in `all.yml`. 

JDK is required, eg:

```sh
sudo apt update
sudo apt install openjdk-11-jdk #(8 or later)
```

Use `metabase.yml` playbook, eg:
```sh
ansible-playbook metabase.yml -i hosts -l staging2.ceresfairfood.org.au --ask-become-pass --user <remote-user>
```

Certificate was set up manually:
```sh
certbot certonly --nginx --email "maikel@openfoodnetwork.org.au" -d "metabase.ceresfairfood.org.au" --renew-hook "systemctl reload nginx"
```

Default login is example@example.com / metabase123

Metabase config includes:

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
- [ ] enable database replication
- [ ] test database replication surviving restarts

```
# set up ufw with all rules, then:
ufw allow from 43.239.97.146 to any port mysql

# edit mysql/mariadb config
# Warning: Debian can have multiple config files and only some are loaded

# On the master:
mysql> CREATE USER 'fairfood'@'%' IDENTIFIED BY 'secret password';
     > GRANT ALL PRIVILEGES ON fairfood_production.* TO 'fairfood'@'%';
     > GRANT REPLICATION SLAVE ON *.* TO 'fairfood'@'%';
mysqldump --skip-lock-tables --single-transaction --flush-logs --hex-blob --master-data=2 fairfood_production > fairfood_production-for-replication.sql
head fairfood_production-for-replication.sql -n80 | grep "MASTER_LOG_FILE" > mysql-position
gzip fairfood_production-for-replication.sql

# on the slave
zcat fairfood_production-for-replication.sql | mysql
mysql> CHANGE MASTER TO MASTER_HOST='43.239.97.8',MASTER_USER='fairfood',MASTER_PASSWORD='secret password', MASTER_LOG_FILE='mysql-bin.000002', MASTER_LOG_POS=106;
     > START SLAVE;
     > SHOW SLAVE STATUS \G
```

Prepare new server:
- [ ] deactivate git post-receive hook for deployments
- [ ] deploy master to new server (start new application)

```
# Tell other devs to not deploy to the old server:
echo "[ERROR] Aborting deploy!"
echo "[Thu 8 Feb 2018] Maikel is about to switch to the new production server."
exit 1
```

Switch delayed jobs:
- [ ] deactivate monit for old delayed job
- [ ] stop old delayed job: `RAILS_ENV=production ./script/delayed_job stop`
- [ ] start new delayed job: `RAILS_ENV=production ./script/delayed_job start`
- [ ] monitor log file: `tail -f /srv/members.ceresfairfood.org.au/current/log/delayed_job.log`

Switch application:
- [ ] nginx proxy pass from old to new app
- [ ] deactivate monit for old application
- [ ] shut down the old application

Switch cron jobs:
- [ ] clear cron jobs on old server
- [ ] install cron jobs on new server
- [ ] update post-receive hook to install cronjobs

Expand Letsencrypt cert on new server:
- [ ] Configure new nginx to listen do production domain
- [ ] Forward http traffic from old to new server
- [ ] /usr/local/share/letsencrypt/env/bin/letsencrypt certonly -w /etc/letsencrypt/webrootauth/ -d prod2.ceresfairfood.org.au -d members.ceresfairfood.org.au --expand

Switch databases:
- [ ] check databases are in sync
- [ ] make new mysql writable
- [ ] change database.yml
- [ ] stop delayed job
- [ ] reload new application
- [ ] make new mysql master `STOP SLAVE; RESET MASTER;`
- [ ] start delayed job

Finishing it off:
- [ ] update post-receive hook on new server
- [ ] install monit on new server
- [ ] change DNS entry
- [ ] copy TLS certificates

```
# Tell other devs to deploy to the new server:
echo "[ERROR] Aborting deploy!"
echo "[Thu 15 Feb 2018] We have a new production server."
echo ""
echo "  git remote set-url production members.ceresfairfood.org.au@prod2.ceresfairfood.org.au:~/current"
exit 1
```
