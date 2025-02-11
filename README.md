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

### LXC, LXD or Incus

On Linux, you can also use a more lightweight container system.

```sh
apt install lxd
lxc remote set-url images https://images.lxd.canonical.com
lxc launch images:debian/11 cff
lxc config device add cff cffport1122 proxy listen=tcp:0.0.0.0:1122 connect=tcp:127.0.0.1:22
lxc config device add cff cffport1443 proxy listen=tcp:0.0.0.0:1443 connect=tcp:127.0.0.1:443
lxc exec cff apt install ssh python3-apt cron
lxc exec cff ssh-keygen
lxc exec cff -- sh -c 'cat >> .ssh/authorized_keys' < ~/.ssh/id_rsa.pub
```

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

 Eg: `ansible-playbook -i hosts -l vagrant site.yml --step --start-at-task='Install configuration files'`

### Snapshots
It's handy to take snapshots to quickly revert back to. Eg:

```
vagrant snapshot save 1-initial
# later
vagrant snapshot save 2-deployed
# later
vagrant snapshot save 3-app-installed
# rollback
vagrant snapshot restore 2-deployed
```

### Git Push
To test the post-receive script, you can push from your local environment.

Vagrant requires use of a different ssh port. As a shortcut, add a new remote in your `fairfood` repository:
```
cd fairfood/
git remote add vagrant ssh://fairfood@localhost:2222/srv/fairfood/current

git push vagrant
```

Once installed, you should be able to access the web app: http://localhost:8080/

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
A checklist for migrating to a new production server is here: [switching-servers.md](switching-servers.md)
