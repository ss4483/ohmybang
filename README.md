Your bundle is locked to mimemagic (0.3.3), but that version could not be found in any of the sources listed in your Gemfile. If you haven't changed sources, that means the author of mimemagic (0.3.3) has
removed it. You'll need to update your bundle to a version other than mimemagic (0.3.3) that hasn't been removed in order to install.

- readme 정리

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

change_column :users, :login, :string, :limit => 55


ssh ss4483@52.141.36.148

sudo passwd = 0000

# 서버 on/off
sudo fuser -k 80/tcp
sudo /opt/nginx/sbin/nginx
sudo /opt/nginx/sbin/nginx -s reload

# 설정
sudo vi /opt/nginx/conf/nginx.conf

# db
<!-- RAILS_ENV=production rake db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1 -->
<!-- RAILS_ENV=production rake db:create -->
RAILS_ENV=production rake db:migrate
RAILS_ENV=production rake db:seed

RAILS_ENV=production bin/rake assets:precompile

RAILS_ENV=production raills console

# bundle install
bundle install --without development test



bundle exec erd



# letsencrypt
1. 설치 the Let's Encrypt client
  sudo git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt
  cd /opt/letsencrypt/
  ./letsencrypt-auto

2. 생성 a Let's Encrypt SSL Cert 
  cd /opt/letsencrypt/
  sudo ./letsencrypt-auto certonly --webroot --webroot-path /home/ss4483/web/public --renew-by-default --email support@ohmybang.com --text --agree-tos -d ohmybang.com
  cd ~
  openssl dhparam -out dhparams.pem 2048
  
3. Configure Nginx
  sudo vi /opt/nginx/conf/nginx.conf
  https://gorails.com/guides/free-ssl-with-rails-and-nginx-using-let-s-encrypt

```
http {
  ...

  server {
      listen 80;
      server_name ohmybang.com;
      return 301 https://$host$request_uri;
    }
  server {
    listen       443 ssl;
    server_name  ohmybang.com;
    passenger_enabled on;
    rails_env production;
    root /home/ss4483/web/public;

    ssl_certificate      /etc/letsencrypt/live/ohmybang.com/fullchain.pem;
    ssl_certificate_key  /etc/letsencrypt/live/ohmybang.com/privkey.pem;

    ssl_session_cache    shared:SSL:10m;
    ssl_session_timeout  5m;

    ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';

    ssl_prefer_server_ciphers  on;
    ssl_dhparam /home/ss4483/dhparams.pem;
  }
}
```

/opt/letsencrypt/letsencrypt-auto renew
-force-renewal

# 롤백
rake db:rollback STEP=1





