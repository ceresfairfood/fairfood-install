# Set up Wordpress website

The database is copied with the main application.

## Obtain certificates

```
certbot -d uat.ceresfairfood.org.au
certbot -d vvv.ceresfairfood.org.au
certbot -d www.ceresfairfood.org.au
```

## Add user and copy files

```
adduser wordpress --home /srv/wordpress --disabled-password --comment ""
usermod -a -G wordpress www-data
chmod g+x /srv/wordpress
systemctl restart php8.4-fpm.service

old=prod3

rsync -avz wordpress@$old.ceresfairfood.org.au:.ssh /srv/wordpress/
rsync -avz wordpress@$old.ceresfairfood.org.au:www /srv/wordpress/
rsync -avz wordpress@$old.ceresfairfood.org.au:vvv /srv/wordpress/
rsync -avz wordpress@$old.ceresfairfood.org.au:sync-staging.sh /srv/wordpress/

scp $old.ceresfairfood.org.au:/etc/nginx/sites-available/uat.ceresfairfood.org.au.conf /etc/nginx/sites-available/
scp $old.ceresfairfood.org.au:/etc/nginx/sites-available/vvv.ceresfairfood.org.au.conf /etc/nginx/sites-available/
scp $old.ceresfairfood.org.au:/etc/nginx/sites-available/www.ceresfairfood.org.au.conf /etc/nginx/sites-available/

cd /etc/nginx/sites-enabled
ln -s ../sites-available/uat.ceresfairfood.org.au.conf
ln -s ../sites-available/vvv.ceresfairfood.org.au.conf
ln -s ../sites-available/www.ceresfairfood.org.au.conf

systemctl reload nginx.service
```
