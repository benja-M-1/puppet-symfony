exec { 'apt-get update':
  command => 'apt-get update',
  path    => '/usr/bin/',
  tries   => 3,
}

class { 'apt':
  always_apt_update => true,
}

package { ['python-software-properties', 'build-essential', 'vim', 'curl']:
  ensure  => 'installed',
  require => Exec['apt-get update'],
}

file { '/home/vagrant/.bash_aliases':
  source => 'puppet:///modules/home/dot/.bash_aliases',
  ensure => 'present',
}

class { "mysql":
    root_password => 'root',
}

mysql::grant { 'symfony':
  mysql_privileges => 'ALL',
  mysql_password => 'vagrant',
  mysql_db => 'symfony',
  mysql_user => 'vagrant',
  mysql_host => 'localhost',
}

class { 'nginx': }

$domain  = "dev.local"
$docroot = "/vagrant/web"

file { $docroot:
    ensure => "directory",
    owner  => "www-data",
    group  => "www-data",
    mode   => 750,
}

file { '/etc/nginx/sites-enabled/default': 
    ensure => absent,
} 

nginx::vhost { $domain:
    docroot        => $docroot,
    create_docroot => false,
    priority       => 10,
    template       => 'nginx/vhost/vhost.conf.erb',
}

apt::ppa { 'ppa:ondrej/php5': }

include php
include php::fpm
php::fpm::pool { 'dev':
  pm_max_children      => 20,
  pm_start_servers     => 10,
  pm_min_spare_servers => 10,
  pm_max_spare_servers => 20,
  pm_max_requests      => 10,
  listen               => "/tmp/app.socket",
  listen_type          => "socket",
  user                 => "www-data",
  group                => "www-data",
  env_settings => [
      "env[HOSTNAME] = $HOSTNAME",
      "env[PATH] = /usr/local/bin:/usr/bin:/bin",
      "env[LANG] = $LANG"
  ],
  php_settings => [
      "php_admin_value[error_log] = /var/log/fpm-php.log"
  ],
  notify => Class["php::fpm::service"],
} 

php::module { ["curl", "mcrypt", "mysql", "sqlite", "intl", "memcache"]:
  notify => Class["php::fpm::service"],
}
php::module { ["apc"]:
  package_prefix => "php-",
  notify => Class["php::fpm::service"],
}

include pecl
exec { "pear_autodiscover":
  command => "/usr/bin/pear config-set auto_discover 1",
  require => Package["php-pear"]
}
pecl::package { 'xdebug': }

class { 'composer':
  command_name => 'composer',
  target_dir   => '/usr/bin'
}

#include nodejs
#package { 'less':
#  ensure   => latest,
#  provider => 'npm',
#}