class gitolite::package (
  $path,
  $user,
  $group = $user,
  $admin_pub_key,
) {

  include gitolite::package::params

  $package = $gitolite::package::params::package
  
  class { "gitolite::package::${::osfamily}":
    path => $path,
    user => $user,
    group => $group,
    admin_pub_key => $admin_pub_key,
  } 
}
