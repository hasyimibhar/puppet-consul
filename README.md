## Usage

Install Consul:

```puppet
class { 'consul':
  user_password => 'password', # password for user 'consul'
  datacenter => 'nyc',
  data_dir => '/var/consul',
  key => '5WMjeV8U07PDbbkOhuqw0A==',
  logfile => '/var/log/consul.log'
}
```

Install Consul Template:

```puppet
class { 'consul::template': }
```

To start Consul as server:

```sh
$ sudo service consul-server start
```

To start Consul as client:

```sh
$ sudo service consul-client start
```

To start bootstrapped Consul:

```sh
$ su consul
$ consul agent -config-dir /etc/consul.d/bootstrap
```
