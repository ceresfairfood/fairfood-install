# OSX Install guide 
[DRAFT]

Install Vagrant and VirtualBox (did these manually, but probably would have been easier to use homebrew)

https://github.com/ceresfairfood/fairfood-install


Install ansible with brew (or maybe pip, but make sure you add to PATH afterwards)

    brew install ansible


Install virt-manager
https://github.com/jeffreywildman/homebrew-virt-manager

    brew tap jeffreywildman/homebrew-virt-manager
    brew install virt-manager virt-viewer


Add your public key to the repo so you can push to the vagrant box, eg:

    cat ~/.ssh/id_rsa.pub >> files/admin-ssh-keys/$USER.pub

Ensure you have an entry in the `./hosts` file for your environment. Eg add vagrant-virtualbox with correct path for ssh private key file:

    vagrant-virtualbox ansible_port=2222 ansible_host=127.0.0.1 ansible_user=vagrant ansible_ssh_private_key_file=.vagrant/machines/default/virtualbox/private_key ansible_ssh_common_args='-o StrictHostKeyChecking=no'

Run the ansible playbook as per readme, for vagrant-virtualbox:

    vagrant up
    ansible-playbook -i hosts -l vagrant-virtualbox site.yml

If things get very broken, try coming back and running vagrant provision and the playbook again.




# Staging environment

Load a data dump:

    zcat ~/old_server.sql.gz | mysql ceres_staging

## Deploy

```
git remote add vagrant ssh://members.ceresfairfood.org.au@localhost:2222/srv/members.ceresfairfood.org.au/current
git push vagrant
```

If you get the nginx welcome message, try reloading nginx.


This might be why?
```
remote: Couldn't reload, starting 'bash -l -c 'cd /srv/members.ceresfairfood.org.au/current; bundle exec unicorn_rails -D -c /srv/members.ceresfairfood.org.au/unicorn.rb -E staging'' instead
remote: master failed to start, check stderr log for details
```


# Local development with separate repo
I tried to use this vagrant environment for local development, but would not recommend this. I never got it fully working. But if you want to try...


Required for shared folders on VirtualBox
`vagrant plugin install vagrant-vbguest`

Add the local fairfood repo folder to vagrant using the members.. user, eg:

    config.vm.synced_folder(
      "../fairfood", 
      "/srv/members.ceresfairfood.org.au/development", 
      owner: "members.ceresfairfood.org.au", 
      group: "members.ceresfairfood.org.au", 
      type: "rsync", rsync__auto: true, rsync__exclude: ['./tmp'])

Also forward the port on for the rails server:

    config.vm.network "forwarded_port", guest: 3000, host: 3030


Log into vagrant and switch to members..

    vagrant up #or reload if already up
    vagrant ssh
    sudo su - members.ceresfairfood.org.au
    cd ~/development

Or better, set up an ssh alias in `~/.ssh/config` and ssh directly:

```
Host cff-vagrant
  HostName 127.0.0.1
  User members.ceresfairfood.org.au
  Port 2222
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentitiesOnly yes
  LogLevel FATAL
``` 

    ssh cff-vagrant

Set the bundle path:

    bundle config --local path "/srv/members.ceresfairfood.org.au/.gem"

now you can bundle install!

    bundle

For a nice touch, add a label to the site config: `config/config.local.yml` (this file is ignored by git and will override the main config):

    development:
      site_title: CERES Fair Food [DEVELOPMENT]

## Database
Setup config/database.yml, find password in `/srv/members.ceresfairfood.org.au/.my.cnf`. Eg:

```yaml
development:
  adapter: mysql2
  encoding: utf8
  reconnect: false
  database: ceres_dev
  pool: 5
  username: fairfood
  password: F2Y.bLEZvZgJJMo
  host: localhost
```

Login as root and grant `fairfood` more permissions to create a new db

    vagrant ssh
    sudo su -
    mysql
    grant all privileges on *.* to fairfood@localhost;

Now you can create the db!

    sudo su - members.ceresfairfood.org.au
    bundle exec rake db:create db:schema:load

You could create an admin user (`bundle exec rake db:seed`), but it's not much good without products, so load the latest db dump and reset the admin password:

    zcat ~/old_server.sql.gz | mysql ceres_dev

Here's a script to reset the test user password:

    bundle exec rails r script/reset-password.rb user@example.org cff123

And finally, your environment should be ready to serve...

    bundle exec rails server

This should be forwarded to your localhost here: http://localhost:3030/ (make sure you use `localhost` which is whitelisted for harmony address autocompletion)

## testing
I never got this working for the whole suite. Firefox seems to die after a while.

To use firefox: first ensure you have `curl` available:

    # install from vagrant user
    sudo apt install curl 

    # Install and save env variable for next time
    sudo su - members.ceresfairfood.org.au
    cd ~/development
    echo "export FIREFOX_BINARY_PATH=$(./script/install-firefox $PWD/tmp)" >> ~/.bash_profile

    bundle exec rake


See branch 1317-upgrade-firefox for more dependencies.

# limitations
I can't (yet) do address validation: `Launchy::CommandNotFoundError`