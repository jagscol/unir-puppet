$document_root = '/vagrant'

include mysql::server

mysql::db { 'wordpress':
  user            => 'wordpress',
  password        => 'yourpasswordhere',
  host            => 'localhost',
  grant           => ['SELECT', 'INSERT','UPDATE','DELETE','CREATE','DROP','ALTER'],
  sql             => ['/vagrant/modules/blog/files/wordpress.sql.gz'],
  import_cat_cmd  => 'zcat',
  import_timeout  => 900,
  mysql_exec_path => '/opt/rh/rh-myql57/root/bin',
}

include blog

# class { 'apache':
#   default_vhost => false,
# }



# include blog

# exec { 'Skip Message':
#   command => "echo ‘Este mensaje sólo se muestra si no se ha copiado el fichero index.html'",
#   unless => "test -f ${document_root}/index.html",
#   path => "/bin:/sbin:/usr/bin:/usr/sbin",
# }

# $ipv4_address = $facts['networking']['ip']
# notify { 'Showing machine Facts':
#   message => "Machine with ${::memory['system']['total']} of memory and ${::processorcount} processor/s.
#               Please check access to http://${ipv4_address}",
# }
