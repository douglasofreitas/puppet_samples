class treinamento::wordpress {

  class {
    phpfpm:
      manage_package => true
  }

  $docroot    = '/var/www/wordpress'
  $sourcefile = '/usr/local/src/wordpress.tar.gz'
  $fpmport    = 9999

	package {
		[ 'php-mysqlnd',
		  'php-gd' ]:
			ensure => 'installed',
			notify => Service['php-fpm']
	}

	user {
		'wordpress':
			ensure     => present,
			uid        => 12345,
			gid        => 12345,
			managehome => false,
			home       => "${docroot}",
			require    => Group['wordpress']
	}

	group {
		'wordpress':
			ensure     => present,
			gid        => 12345
	}

	file {
		"${sourcefile}":
			ensure  => present,
			source  => 'https://wordpress.org/latest.tar.gz',
			notify  => Exec['unzip-wordpress'],
			require => File["${docroot}"];

		[ '/var/www',
		  "${docroot}" ]:
			ensure  => directory,
			owner   => 'wordpress',
			group   => 'wordpress',
			recurse => true,
			mode    => '0775';
	}

	exec {
		'unzip-wordpress':
			refreshonly => true,
			command     => "/bin/tar -xzvf ${sourcefile} -C ${docroot} --strip-components 1",
			unless      => "/bin/test -d ${docroot}/wp-content",
			require     => File["${sourcefile}"]
	}

	phpfpm::pool {
			'www':
				ensure => 'absent'
	}

	phpfpm::pool {
		'wordpress':
			listen  => "127.0.0.1:${fpmport}",
			user    => 'wordpress',
			group   => 'wordpress',
			require => [ User['wordpress'],
			             Group['wordpress']
			           ]
	}

	service {
		'selinux':
			ensure => 'stopped'
	}
}
