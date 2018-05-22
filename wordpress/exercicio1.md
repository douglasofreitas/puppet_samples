## Exercício Puppet

### Objetivo
Fazer um setup do *Wordpress* com *Nginx* + *PHP-FPM* + *MySQL* em um servidor *CentOS*.
Sempre que possível, recomenda-se a utilização de módulos da comunidade ([Puppet Forge](https://forge.puppet.com/)) para realizar as tarefas.

### Orientações gerais
* Para rodar a automação, acesse o servidor disponibilizado e roda o comando `sudo puppet-apply`.
* Recorra à documentação dos módulos para exemplos de como utilizá-los.
* Lembre-se das dependências de cada recurso (`requires => ...`).
* Pensem em quais recursos precisam *triggar* (`notify => ...`) outros.
* Se necessário, outros arquivos podem ser criados no mesmo diretórios dos manifestos Puppet, e usado como `source` de recursos do tipo `file`, da seguinte maneira:
```
file {
  '/path/to/file':
    source => "${::basepath}/myfilename"
}
```

### Passos
#### Arquivo `init.pp`
Deve conter a classe-mãe `treinamento`, onde cada uma das subclasses indicadas abaixo devem ser incluídas.

#### Arquivo `Puppetfile`
Arquivo onde serão adicionados os módulos utilizados.

#### Arquivo `database.pp`
Deve conter a classe `treinamento::database`, com os seguintes recursos:
 - instalação *MySQL Server*
 - criação database de nome `wordpress`, com usuário `wp_admin`, com acesso liberado para `localhost` e os seguintes grants: `CREATE, SELECT, DELETE, ALTER, INSERT, UPDATE, TRIGGER`

Dicas:
  - usar módulo `puppetlabs/mysql`.

#### Arquivo `wordpress.pp`
Deve conter classe `treinamento::wordpress`, com os seguintes recursos:
 - pacotes `php-mysqlnd` e `php-gd`
 - usuário e grupo `wordpress`
 - baixar tarball do *Wordpress* e descompactar em `/var/www/wordpress`
 - instalar e configurar *PHP-FPM*
 - configurar pool do *Wordpress* no *PHP-FPM*, escutando em `localhost:9999` e subindo com usuário/grupo `wordpress/wordpress`
 - `selinux` desabilitado

Dicas:
- usar módulo `Slashbunny-phpfpm`
- baixar tarball do Wordpress com resource do tipo `file`, e descompactar com `exec`

#### Arquivo `nginx.pp`
Deve conter classe `treinamento::nginx`, com os seguintes recursos:
  - instalar e configurar serviço *Nginx*
  - server HTTP default (porta 80)
  - location `/` com *fastcgi* configurado para pool *PHP-FPM* configurado no módulo anterior e *DocumentRoot* em `/var/www/wordpress`

Dicas:
  - usar módulo `puppet/nginx`
  - use variáveis dentro das classes para definir valores que se repetem (por exemplo, docroot, porta, etc)
