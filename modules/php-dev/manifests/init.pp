class php-dev::install {
    package { 'php5-gd':
        ensure => installed,
        require => Class['php-cli']
    }
}

class php-dev {
    include php-dev::install
}
