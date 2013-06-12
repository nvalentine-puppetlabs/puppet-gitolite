class gitolite::package::redhat::params {
  $admin_pub_key_file = "/var/lib/gitolite/admin.pub"

  if ($::operatingsystemrelease > 6) {
    $epel_url = 'http://mirrors.servercentral.net/fedora/epel/6/i386/epel-release-6-8.noarch.rpm'
  } elsif ($::operatingsystemrelease < 7 and $::operatingsystem > 5) {
    $epel_url = 'http://mirror.pnl.gov/epel/5/i386/epel-release-5-4.noarch.rpm'
  } else {
    fail("${::osfamily} release ${::operatingsystemrelease} not supported!")
  }
}
