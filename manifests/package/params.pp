class gitolite::package::params {

  include gitolite::params 

  case $::osfamily {
    'debian': { $preseed = '/var/cache/debconf/gitolite.preseed' }

    'redhat' : {
      if !('6.4' == $operatingsystemrelease) { 
	fail("Sorry, this class supports RedHat version 6.4 only!")
      }
      $epel_url = 'http://mirrors.servercentral.net/fedora/epel/6/i386/epel-release-6-8.noarch.rpm'
      $admin_pub_key_file = '/tmp/admin.pub'
    }

    default: {fail("OS family ${::osfamily} not supported by this class!")}
  }

  $package = ['gitolite']
}
