class gitolite::package (
  $path,
  $user,
  $group = $user,
  $admin_pub_key,
  $enable_third_party_package_repo = true
) {

  include gitolite::package::params


  $package = $gitolite::package::params::package

  ##
  ## Debian
  ##

  if 'debian' == $::osfamily {

    user { $user: 
      ensure => present, 
      system => true, 
      gid => $group,
      home => $path,
    }
    group { $group: ensure => present, system => true, }

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

    package { $package: ensure => present, }
 
    Exec { path => ['/sbin','/bin','/usr/bin','/usr/sbin'], }

    exec { "rename gitolite user to $user": 
      command => "usermod -m -d $gitolite::path -l $user gitolite",
      unless => 'getent passwd git',
      require => Exec['configure gitolite admin'],
    } 

    exec { "rename gitolite group to $group": 
      command => "groupmod -n $group gitolite",
      unless => 'getent group git',
      require => Exec['configure gitolite admin'],
    } 

    file { $gitolite::package::params::admin_pub_key_file:
      ensure => file,
      content => $gitolite::admin_pub_key,
    } -> exec { 'configure gitolite admin':
      path => ['/bin','/sbin','/usr/bin','/usr/sbin'],
      environment => ["HOME=/var/lib/gitolite"],
      user => 'gitolite',
      command => "gl-setup -q $gitolite::package::params::admin_pub_key_file > /tmp/foo 2>&1",
      require => Package[$package],
      unless => "test -s $gitolite::path/.ssh/authorized_keys",
    }
  }
}
