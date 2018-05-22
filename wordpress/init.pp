class treinamento {
	include treinamento::database
	include treinamento::wordpress
	include treinamento::nginx
	class { selinux:
		mode => 'disabled'
	}
}
