class treinamento::nginx {

	$address = "*.naturacloud.com"

  include nginx

	nginx::resource::server {
		"${address}":
			ensure      => present,
			www_root    => "${::treinamento::wordpress::docroot}",
			index_files => [ 'index.php' ],
	}

 	nginx::resource::location {
 		"wordpress_root":
			ensure              => present,
			www_root            => "${::treinamento::wordpress::docroot}",
			server              => "${address}",
		  location            => '~ \.php$',
			index_files         => ['index.php', 'index.html', 'index.htm'],
			proxy               => undef,
			fastcgi             => "127.0.0.1:${::treinamento::wordpress::fpmport}",
			fastcgi_script      => undef,
			location_cfg_append => {
				fastcgi_connect_timeout => '3m',
				fastcgi_read_timeout    => '3m',
				fastcgi_send_timeout    => '3m'
			}
	}
}
