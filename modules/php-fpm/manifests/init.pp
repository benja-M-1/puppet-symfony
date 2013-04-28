class php-fpm::install {
    package { 'php5-fpm':
        ensure => installed,
        require => Class['php-cli']
    }
    package { 'php5-mysql':
        ensure => installed,
        require => Package['php5-fpm'],
        notify => Service['php5-fpm']
    }
}

class php-fpm::configure {
    file { '/etc/php5/fpm/pool.d/www.conf':
        content => template('php-fpm/pool.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '755',
    }
}

class php-fpm::run {
    service { php5-fpm:
        enable => true,
        ensure => running,
        hasstatus => true,
        hasrestart => true,
        require => Class['php-fpm::install', 'php-fpm::configure'],
    }
}

class php-fpm {
    include php-fpm::install
    include php-fpm::configure
    include php-fpm::run
}
