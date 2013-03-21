class gitolite::params {
  case $::osfamily {
    'debian': { }
    default: {fail("OS family ${::osfamily} not supported by this class!")}
  }
}