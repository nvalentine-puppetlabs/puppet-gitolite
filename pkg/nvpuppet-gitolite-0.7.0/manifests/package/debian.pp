class gitolite::package::debian(
  $path,
  $user,
  $group,
  $admin_pub_key,
  $preseed = '/var/cache/debconf/gitolite.preseed'
) {

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

  file { $preseed:
    path => $preseed,
    owner => 'root',
    group => 'root',
    mode => '0600',
    content => template('gitolite/Debian/gitolite.preseed.erb'),
  }

  package { 'gitolite':
    ensure => present,
    responsefile => $preseed,
    require => [File[$preseed, $path], User[$user]],
  }
}
