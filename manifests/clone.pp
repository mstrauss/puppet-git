# Define: git::clone
# Parameters:
#   name: the repository (destinatiopn) path
#   from: the repository url
# Example:
#   git::clone { '/var/local/diaspora':
#     from   => 'https://github.com/diaspora/diaspora.git',
#     user   => diaspora, group => diaspora,
#     ensure => present,
#   }
#
define git::clone ( $from, $ensure = present, $owner = root, $group = root ) {
  
  Class[git] -> Git::Clone[$name]
  
  file { $name:
    ensure  => $ensure ? {
      present => directory,
      default => absent,
    },
    owner   => $owner,
    group   => $group,
    recurse => false,
    # in case this ressource needs to be absent, we make sure it will be;
    # it's in git anyway
    force   => true,
  }
  
  if $ensure == present {
    exec { "git clone ${name}":
      subscribe   => File[$name],
      command     => "/usr/bin/git clone '${from}' '${name}'",
      # onlyif this is NOT a valid git repository
      unless      => "/usr/bin/env test -d '${name}/.git'",
    }
    
    # fix owner/group in a more resource-saving way (fresh clones only!)
    exec { "chown on ${name}":
      refreshonly => true,    # only on fresh clones!
      subscribe => Exec["git clone ${name}"],
      command   => "/bin/chown -Rc ${owner}:${group} '${name}'",
      unless    => "/usr/bin/test -z \$( /usr/bin/find '${name}' ! -user ${owner} -or ! -group ${group} )",
    }
    
  }
  
}
