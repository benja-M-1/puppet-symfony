class bower {
    package { 'bower':
	    provider => npm,
	    require => Class['nodejs'],
    }
}