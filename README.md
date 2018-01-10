# fairfood-install

[Ansible](http://docs.ansible.com/ansible/) scripts to install Ceres Fair Food on a server

## Test it locally

```sh
vagrant up
ansible-playbook -i hosts -l vagrant site.yml
```

## Community Roles

Some community roles have been added to the project with:

```sh
ansible-galaxy install -p roles -r requirements.yml
```

## Notes

Install newer version of Ansible on Debian Wheezy: http://brentgclark.blogspot.com.au/2015/08/today-was-interesting-day.html

You can run these scripts on a local virtual machine.
The Vagrantfile in this directory makes that easy:

```sh
sudo apt-get install virtualbox vagrant
vagrant up
vagrant ssh # to login
```
