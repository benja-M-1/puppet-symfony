class less {
	package { 'less':
      	provider => npm,
      	require => Class['nodejs'],
    }
}