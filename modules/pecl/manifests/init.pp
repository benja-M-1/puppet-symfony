class pecl(
  $package = $pecl::params::package
) inherits pecl::params {

  # Install the PECL package.
  if !defined(Package[$package]) {
    package { $package:
      ensure => installed,
    }
  }

  package {'php-pear':
  	ensure => installed;
  }
}
