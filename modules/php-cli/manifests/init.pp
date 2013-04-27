class php-cli::install {
    package { 'php5-cli':
        ensure => installed
    }
    package { 'php5-sqlite':
        ensure => installed
    }
    package { 'php5-intl':
        ensure => installed
    }
    package { 'php5-curl':
        ensure => installed
    }
    package { 'php-apc':
        ensure => installed
    }
    package { 'php-pear':
        ensure => installed
    }
    exec { 'pear-auto-discover':
        path => '/usr/bin:/usr/sbin:/bin',
        onlyif => 'test "`pear config-get auto_discover`" = "0"',
        command => 'pear config-set auto_discover 1 system',
    }
    exec { 'pear-update':
        path => '/usr/bin:/usr/sbin:/bin',
        command => 'pear update-channels && pear upgrade-all',
    }
    exec { 'install-xdebug':
        unless => 'pecl list | grep xdebug',
        path => '/usr/bin:/usr/sbin:/bin',
        command => 'pecl install xdebug',
        require => [Exec['pear-auto-discover'], Exec['pear-update']],
    }
    file { '/etc/php5/conf.d/xdebug.ini':
        ensure => file,
        content => template('php-cli/xdebug.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '755',
        require => Exec['install-xdebug']
    }
}

class php-cli::configure {
    file { '/etc/php5/conf.d/dev.ini':
        content => template('php-cli/dev.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '755',
    }
}

class php-cli {
    include php-cli::install
    include php-cli::configure
}
