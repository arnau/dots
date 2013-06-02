$home = '/home/vagrant'
$locale = 'en_US.UTF-8'

Exec {
  path => ['/bin', '/usr/bin', '/usr/local/bin', '/usr/sbin']
}

class { dots: }
