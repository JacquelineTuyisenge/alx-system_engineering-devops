# puppet code to install & configure 'nginx'
package { 'nginx':
  ensure => installed,
}

file { '/etc/nginx/sites-available/default':
  content => "server {
                listen 80 default_server;
                listen [::]:80 default_server;

                root /var/www/html;
                index index.html index.htm index.nginx-debian.html;

                server_name _;

                add_header X-Served-By $hostname;

                location / {
                        try_files $uri $uri/ =404;
                }
        }",
  mode    => '0644',
  require => Package['nginx'],
}

file { '/etc/nginx/sites-enabled/default':
  ensure => 'link',
  target => '/etc/nginx/sites-available/default',
  notify => Service['nginx'],
}

service { 'nginx':
  ensure     => 'running',
  enable     => true,
  subscribe  => File['/etc/nginx/sites-enabled/default'],
}
