# puppet-gitolite

Install and configure gitolite.

Currently only Debian ::osfamily supported.

## Usage 

    class { 'gitolite':
      admin_pub_key => '<pub key>',
    }

### Optional parameters
* path : filesystem root for gitolite user account and repos. (default: /srv/git)
* user : user for gitolite (default: git)

## Bug reports
Please file bug reports to Issues on GitHub.

## Contact
Nathan R Valentine <nathan@puppetlabs.com> | <nrvale0@gmail.com>
