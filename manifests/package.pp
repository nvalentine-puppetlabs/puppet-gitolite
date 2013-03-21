class gitolite::package (
  $path,
  $user,
  $group = $user,
  $admin_pub_key
) {

  include gitolite::package::params

  $preseed = $gitolite::package::params::preseed
  $package = $gitolite::package::params::package
 
  user { $user: 
    ensure => present, 
    system => true, 
    gid => $group,
    home => $path,
  }

  group { $group: ensure => present, system => true, }

  file { $path: 
    ensure => directory,
    owner => $user,
    group => $user,
    mode => '0755',
  }

  file { 'gitolite::package preseed':
    path => $preseed,
    owner => 'root',
    group => 'root',
    mode => '0600',
    content => template('gitolite/Debian/gitolite.preseed.erb'),
  }

  package { $package:
    ensure => present,
    responsefile => $preseed,
    require => File[$preseed, $path],
  }
}