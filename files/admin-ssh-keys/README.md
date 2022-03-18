# SSH public keys of admin users

If you place public keys of admin users in this directory, an admin user will
be created for each file and ssh access will be allowed with the key. The files
have to be named `username.pub` and can contain more than one key. Examples:

- andy.pub
- maikel.pub
- kristina.pub


Run the `add-users` playbook anytime to add new users:

    ansible-playbook -i hosts -l staging2.ceresfairfood.org.au add-users.yml --ask-become-pass
