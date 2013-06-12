class gitolite::package::redhat(
  $path,
  $user,
  $group,
  $admin_pub_key
) {

  include gitolite::package::redhat::params

  package { 'epel-release':
    ensure => present,
    provider => 'rpm',
    source => $gitolite::package::redhat::params::epel_url,
  } 

  yumrepo { 'epel': 
    enabled => '1',
    require => Package['epel-release'],
  }

  package { 'gitolite':
    ensure => present,
    require => Yumrepo['epel'],
  }

  Exec { path => ['/sbin','/bin','/usr/bin','/usr/sbin'], }

  exec { "rename gitolite user to ${user}":
    command => "usermod -m -d $path -l $user gitolite",
    unless => 'getent passwd git',
    require => Package['gitolite'],
  } 

  exec { "rename gitolite group to ${group}": 
    command => "groupmod -n $group gitolite",
    unless => 'getent group git',
    require => Package['gitolite'],
  } 

  file { "${path}/admin.pub":
    ensure => file,
    content => $admin_pub_key,
    require => Exec["rename gitolite user to ${user}","rename gitolite group to ${group}"],
  }

  exec { 'configure gitolite admin':
    command => "su -l $user -c \'gl-setup -q ${path}/admin.pub\'",
    require => File["${path}/admin.pub"],
    unless => "test -s ${path}/.ssh/authorized_keys",
  }
}
