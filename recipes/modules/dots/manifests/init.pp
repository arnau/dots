class dots {

  if ! defined(Package['git']) {
    package { 'git': ensure => installed }
  }

  if ! defined(Package['tig']) {
    package { 'tig': ensure => installed }
  }

  if ! defined(Package['vim-nox']) {
    package { 'vim-nox': ensure => installed }
  }

  if ! defined(Package['tmux']) {
    package { 'tmux': ensure => installed }
  }

  if ! defined(Package['task']) {
    package { 'task': ensure => installed }
  }

  if ! defined(Package['htop']) {
    package { 'htop': ensure => installed }
  }

  if ! defined(Package['iftop']) {
    package { 'iftop': ensure => installed }
  }

  exec { 'vendors':
    command => 'git submodule sync && git submodule update --init --recursive',
    cwd => "${home}/.dots",
    refreshonly => true,
  }

  exec { 'zsh':
    command => 'chsh -s $(which zsh)',
    unless => '/bin/echo $SHELL | grep zsh',
  }

  file { 'zshrc':
    ensure => link,
    path => "${home}/.bashrc",
    source => "${home}/.dots/zsh/zshrc",
    owner => 'vagrant',
    group => 'vagrant',
    mode => 0644,
    require => Exec['zsh'],
  }

  file { 'tmux.conf':
    ensure => link,
    path => "${home}/.tmux.conf",
    target => "${home}/.dots/tmux.conf",
    owner => 'vagrant',
    group => 'vagrant',
    mode => 0640,
    require => Package['tmux'],
  }

  file { 'gitconfig':
    ensure => link,
    path => "${home}/.gitconfig",
    target => "${home}/.dots/git/gitconfig",
    owner => 'vagrant',
    group => 'vagrant',
    mode => 0640,
    require => Package['tmux'],
  }



  #file { 'ssh-key':
    #ensure => file,
    #path => '/home/vagrant/.ssh/id_rsa',
    #source => 'puppet:///modules/dots/id_rsa',
    #owner => 'vagrant',
    #group => 'vagrant',
    #mode => 0600,
  #}
  #file { 'authorized_keys':
    #ensure => file,
    #path => '/home/vagrant/.ssh/authorized_keys',
    #source => 'puppet:///modules/dots/authorized_keys',
    #owner => 'vagrant',
    #group => 'vagrant',
    #mode => 0600,
  #}
  #file { 'known_hosts':
    #ensure => file,
    #path => '/home/vagrant/.ssh/known_hosts',
    #source => 'puppet:///modules/dots/known_hosts',
    #owner => 'vagrant',
    #group => 'vagrant',
    #mode => 0644,
  #}



  #exec { 'vigor':
    #command => '/usr/bin/git clone git@github.com:arnau/Vigor.git /home/vagrant/.vim',
    #require => [File['ssh-key'], Package['git'], File['known_hosts']],
    #creates => '/home/vagrant/.vim',
  #}
  #exec { 'vimconfig-install':
    #cwd => '/home/vagrant/.vim',
    #command => '/opt/vagrant_ruby/bin/rake install',
    #require => [Exec['vigor'], Package['rake']],
    #creates => '/home/vagrant/.vimrc',
    #before => Exec['vigor-update'],
  #}
  #exec { 'vigor-update':
    #cwd => '/home/vagrant/.vim',
    #command => '/opt/vagrant_ruby/bin/rake update',
  #}


}
