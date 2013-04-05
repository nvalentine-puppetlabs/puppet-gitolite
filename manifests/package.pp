class gitolite::package (
  $path,
  $user,
  $group = $user,
  $admin_pub_key,
  $enable_third_party_package_repo = true
) {

  include gitolite::package::params

  user { $user: 
    ensure => present, 
    system => true, 
    gid => $group,
    home => $path,
  }

  group { $group: ensure => present, system => true, }

  $package = $gitolite::package::params::package

  ##
  ## Debian
  ##

  if 'debian' == $::osfamily {
    $preseed = $gitolite::package::params::preseed

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
      require => [File[$preseed, $path], User[$user]],
    }
  }

  ##
  ## RedHat
  ## 

  if ('redhat' == $::osfamily) {
    if (true == $enable_third_party_package_repo) {
      package { 'epel-release':
        ensure => present,
        provider => 'rpm',
	source => $gitolite::package::params::epel_url,
      } -> yumrepo { 'epel': enabled => '1', }
    }

    file { $path: ensure => symlink, target => '/var/lib/gitolite', }

    package { $package: ensure => present, }

    file { $gitolite::package::params::admin_pub_key_file:
      owner => 'gitolite',
      group => 'gitolite',
      content => $admin_pub_key,
      require => Package[$package],
    }

    exec { 'configure admin access to gitolite':
      path => ['/bin','/sbin','/usr/bin','/usr/sbin'],
      command => "gl-setup $gitolite::package::params::admin_pub_key_file",
      require => [Package[$package], File[$gitolite::package::params::admin_pub_key_file]],
    }
  }
}
