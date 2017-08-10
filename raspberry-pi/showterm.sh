#!/bin/bash -e

showterm()
{
    if [ ! -d $showterm ]; then
        dfx sudo chown $user:$user /var/www
        dfx git clone --depth 1 'https://github.com/ConradIrwin/showterm.io' $showterm
    fi
    aptinstall libpq-dev libsqlite3-dev
    pushd $showterm
        cat << EOF | tee /var/www/showterm/config/database.yml
development:
  adapter: sqlite3
  database: $showterm/showterm.sqlite3
  pool: 5
  timeout: 5000
EOF
        dfout2 rbenv install 2.2.2
        ruby --version | grep 'ruby 2.2.2' || CONFIGURE_OPTS="--disable-install-rdoc" rbenv install 2.2.2
        rbenv global 2.2.2
        dfx gem install --no-ri --no-rdoc bundler
        grep gem < $HOME/.zshenv || cat << "EOF" | tee -a $HOME/.zshenv
export PATH="$HOME/.gem/ruby/2.2.0/bin:$PATH"
EOF
        export PATH="$HOME/.gem/ruby/2.2.0/bin:$PATH"
        dfx bundle install
        dfx patch -bNp0 '<' $HOME/dotfiles/patch/showterm/application.html.erb.patch
        dfx bundle exec rake db:create db:migrate db:seed
        dfx bundle exec rake assets:precompile
    popd

}

showterm_conf()
{
    cat << EOF | sudo tee /etc/systemd/system/showterm.service
[Unit]
Description=Recording terminal service

[Service]
User=$user
ExecStart=$showterm/run.sh
WorkingDirectory=$showterm

[Install]
WantedBy=multi-user.target
EOF

    cat << EOF | sudo tee $showterm/run.sh
#!/bin/sh -e
(
export PATH="\$HOME/.gem/ruby/2.2.0/bin:\$HOME/.rbenv/bin:\$HOME/.rbenv/shims:\$PATH"
which ruby
which rbenv
rbenv global 2.2.2
$showterm/script/rails server --binding 0.0.0.0 --port 8081
) >>/var/log/showterm.log 2>&1
EOF
    dfx sudo chmod +x $showterm/run.sh

    cat << EOF | sudo tee /etc/logrotate.d/showterm
/var/log/showterm.log {
    weekly
    coppytruncate
    rotate 52
    ocmpress
    delaycompress
    notifempty
}
EOF
    dfx sudo touch /var/log/showterm.log
    dfx sudo chown $user:$user /var/log/showterm.log
    
    dfx sudo systemctl restart showterm
    dfx sudo systemctl enable gitbucket.service
}

showterm_nginx()
{
    cat << EOF | sudo tee /etc/nginx/sites-available/showterm.conf
server {
    listen 80;
    server_name record.$domain;
    charset UTF-8;
    proxy_set_header Host \$http_host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_redirect off;
    proxy_max_temp_file_size 0;
    error_page 404 404.html;
    error_page 422 422.html;
    error_page 500 500.html;

    location /.well-known {
        alias /var/www/html/.well-known;
    }

    location / {
        proxy_pass http://localhost:8081;
        proxy_connect_timeout   150;
        proxy_send_timeout      100;
        proxy_read_timeout      100;
        proxy_buffers           4 32k;
        client_max_body_size    500m; # Big number is we can post big commits.
        client_body_buffer_size 128k;

    }

    location /robots.txt {
        alias /var/www/html/robots-disallow.txt;
    }

    location /assets/ {
        proxy_pass              http://localhost:8081/assets/;
        proxy_cache             cache;
        proxy_cache_key         \$host\$uri\$is_args\$args;
        proxy_cache_valid       200 301 302 1d;
        expires                 1d;
    }

    location /console/ {
        deny all;
    }
}
EOF
    dfx sudo ln -sfnv /etc/nginx/sites-available/showterm.conf \
        /etc/nginx/sites-enabled/showterm.conf
    dfx sudo systemctl reload nginx.service
}

export -f showterm
export -f showterm_conf
export -f showterm_nginx

