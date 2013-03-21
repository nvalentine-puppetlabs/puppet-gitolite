class gitolite (
  $path = '/srv/git',
  $user = 'git',
  $admin_pub_key
) {
  include gitolite::params

  class { 'gitolite::package':
    user => $user,
    path => $path,
    admin_pub_key => $admin_pub_key,
  }
}