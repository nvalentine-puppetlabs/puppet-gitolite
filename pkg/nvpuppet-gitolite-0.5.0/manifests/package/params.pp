class gitolite::package::params {

  include gitolite::params 

  case $::osfamily {
    'debian': { 
      $preseed = '/var/cache/debconf/gitolite.preseed'
      $package = ['gitolite']
    }
    default: {fail("OS family ${::osfamily} not supported by this class!")}
  }
}