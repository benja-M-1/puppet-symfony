class dev {
    package { 'acl':
        ensure => installed
    }
    package { 'curl':
        ensure => installed
    }
    package { 'git':
        ensure => installed
    }
    package { 'make':
        ensure => installed
    }
    package { 'python':
        ensure => installed
    }
    package { 'g++':
        ensure => installed
    }
    package { 'wget':
        ensure => installed
    }
    package { 'tar':
        ensure => installed
    }
}
