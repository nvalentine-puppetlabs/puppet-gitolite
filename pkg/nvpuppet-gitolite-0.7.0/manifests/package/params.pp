class gitolite::package::params {

  include gitolite::params 

  case $::osfamily {
    'debian': {}
    'redhat' : {}
    default: {fail("OS family ${::osfamily} not supported by this class!")}
  }
}
