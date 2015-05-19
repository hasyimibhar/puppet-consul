class consul(
  $user_password,
  $datacenter,
  $data_dir,
  $key,
  $logfile
) {

  package { 'wget':
    ensure => installed
  }

  package { 'unzip':
    ensure => installed
  }

  exec { 'wget-consul':
    path => '/usr/local/bin:/usr/bin:/usr/sbin:/bin',
    command => 'wget https://dl.bintray.com/mitchellh/consul/0.5.0_linux_amd64.zip',
    cwd => '/usr/local/bin',
    creates => '/usr/local/bin/0.5.0_linux_amd64.zip',
    onlyif => 'test ! -f /usr/local/bin/consul',
    require => Package['wget']
  }

  exec { 'unzip-consul':
    path => '/usr/local/bin:/usr/bin:/usr/sbin:/bin',
    command => 'unzip *.zip',
    cwd => '/usr/local/bin',
    creates => '/usr/local/bin/consul',
    require => [ Exec['wget-consul'], Package['unzip'] ]
  }

  exec { 'cleanup-consul':
    path => '/usr/local/bin:/usr/bin:/usr/sbin:/bin',
    command => 'rm *.zip',
    cwd => '/usr/local/bin',
    onlyif => 'test -f /usr/local/bin/0.5.0_linux_amd64.zip',
    require => Exec['unzip-consul']
  }

  user { 'consul':
    ensure => present,
    home => '/home/consul',
    password => $user_password
  }

  file { $data_dir:
    ensure => directory,
    owner => 'consul',
    group => 'consul',
    require => User['consul']
  }

  file { '/etc/consul.d':
    ensure => directory,
    owner => 'consul',
    group => 'consul',
    require => User['consul']
  }

  file { '/etc/consul.d/bootstrap':
    ensure => directory,
    owner => 'consul',
    group => 'consul',
    require => File['/etc/consul.d']
  }

  file { '/etc/consul.d/server':
    ensure => directory,
    owner => 'consul',
    group => 'consul',
    require => File['/etc/consul.d']
  }

  file { '/etc/consul.d/client':
    ensure => directory,
    owner => 'consul',
    group => 'consul',
    require => File['/etc/consul.d']
  }

  file { '/etc/consul.d/bootstrap/config.json':
    ensure => present,
    content => template('consul/bootstrap.json.erb'),
    require => [ Exec['unzip-consul'], File['/etc/consul.d/bootstrap'] ]
  }

  file { '/etc/consul.d/server/config.json':
    ensure => present,
    content => template('consul/server.json.erb'),
    require => [ Exec['unzip-consul'], File['/etc/consul.d/server'] ]
  }

  file { '/etc/consul.d/client/config.json':
    ensure => present,
    content => template('consul/client.json.erb'),
    require => [ Exec['unzip-consul'], File['/etc/consul.d/client'] ]
  }

  file { '/etc/init/consul-server.conf':
    ensure => present,
    content => template('consul/consul-server.conf.erb')
  }

  file { '/etc/init/consul-client.conf':
    ensure => present,
    content => template('consul/consul-client.conf.erb')
  }

  file { $logfile:
    ensure => present,
    owner => 'consul',
    group => 'consul'
  }
}
