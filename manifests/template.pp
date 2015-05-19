class consul::template() {

  exec { 'wget-consul-template':
    path => '/usr/local/bin:/usr/bin:/usr/sbin:/bin',
    command => 'wget https://github.com/hashicorp/consul-template/releases/download/v0.9.0/consul-template_0.9.0_linux_amd64.tar.gz',
    cwd => '/usr/local/bin',
    creates => '/usr/local/bin/consul-template_0.9.0_linux_amd64.tar.gz',
    onlyif => 'test ! -f /usr/local/bin/consul-template',
    require => Package['wget']
  }

  exec { 'tar-consul-template':
    path => '/usr/local/bin:/usr/bin:/usr/sbin:/bin',
    command => 'tar xvf *.tar.gz --strip-components 1',
    cwd => '/usr/local/bin',
    creates => '/usr/local/bin/consul-template',
    require => Exec['wget-consul-template']
  }

  exec { 'cleanup-consul-template':
    path => '/usr/local/bin:/usr/bin:/usr/sbin:/bin',
    command => 'rm *.tar.gz',
    cwd => '/usr/local/bin',
    require => Exec['tar-consul-template']
  }
}
