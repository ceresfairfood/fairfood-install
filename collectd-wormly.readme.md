
Instructions adapted from: https://www.wormly.com/help/collectd-plugins/nginx-monitoring

Check requirement `http_stub_status`

    nginx -V 2>&1 | grep with-http_stub_status

Add nginx config with this playbook, or manually add and reload.

    ansible-playbook collectd-wormly.yml -i hosts -l staging2.ceresfairfood.org.au --ask-become-pass --user <remote-user>

This adds to: `/etc/nginx/sites-available/nginx_status.conf`, links it in `sites-enabled` and reloads nginx.

The nginx role also disables the `default` site which is not intended. TODO: merge this into the main

Confirm:

    curl http://localhost:8081/nginx_status

Then add the following config in: `/etc/collectd/collectd.conf.d/monitor-nginx.conf`

```xml
LoadPlugin nginx
<Plugin "nginx">
    URL "http://localhost:8081/nginx_status"
</Plugin>
```

Confirm config is "ok", and reload

    sudo collectd -T
    sudo systemctl restart collectd
