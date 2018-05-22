class treinamento::database {

  $user   = 'wp_user'
  $passwd = 'r2d2c3po'
  $db     = 'wordpress'

	include 'mysql::server'

	mysql::db {
		'wordpress':
			user     => "${user}",
			password => "${passwd}",
			dbname   => "${db}",
			host     => 'localhost',
			grant    => [ 'CREATE', 'SELECT', 'DELETE', 'ALTER', 'INSERT', 'UPDATE', 'TRIGGER' ]
	}
}
