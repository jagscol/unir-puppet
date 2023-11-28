class blog {

  package { 'mysql-server':
    ensure => installed,
  }

  file { '/vagrant/modules/blog/files/wordpress.sql':
    ensure => present,
    source => '/vagrant/modules/blog/files/wordpress.sql',
  }

  exec { 'mysql':
    command => 'mysql < /vagrant/modules/blog/files/wordpress.sql',
    path    => ['/usr/bin', '/usr/sbin',],
    require => Package['mysql-server'],
  }

  package { 'php':
    ensure => installed,
  }

  package { 'apache2':
    ensure => installed,
  }

  package { 'wordpress':
    ensure => installed,
  }

  file { '/etc/apache2/sites-enabled/000-default.conf':
    ensure  => absent,
    require => Package['apache2'],
  }

  file { '/etc/apache2/sites-available/wordpress.conf':
    content => template('blog/virtual-hosts.conf.erb'),
    require => File['/etc/apache2/sites-enabled/000-default.conf'],
  }

  file { '/etc/apache2/sites-enabled/wordpress.conf':
    ensure  => link,
    target  => '/etc/apache2/sites-available/wordpress.conf',
    require => File['/etc/apache2/sites-available/wordpress.conf'],
    notify  => Service['apache2'],
  }

  file { '/etc/wordpress/config-localhost.php':
    content => template('blog/config-localhost.php.erb'),
    require => Package['wordpress'],
  }

  service { 'apache2':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    restart   => '/usr/sbin/apachectl configtest && /usr/sbin/service apache2 reload',
  }

  notify { 'URL to access the blog':
    message => 'Please check access to http://localhost:8080',
  }

}
