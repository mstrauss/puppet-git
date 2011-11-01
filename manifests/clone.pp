# Define: git::clone
# Parameters:
#   from: the repository url
# Example:
#   git::clone { '/var/local/diaspora':
#     from   => 'https://github.com/diaspora/diaspora.git',
#     user   => diaspora, group => diaspora,
#     ensure => present,
#   }
#
define git::clone ( $from, $ensure = present, $owner = root, $group = root ) {

  file { $name:
    ensure  => $ensure ? {
      present => directory,
      default => absent,
    },
    owner   => $owner,
    group   => $group,
    recurse => true,
    # in case this ressource needs to be absent, we make sure it will be;
    # it's in git anyway
    force   => true,
  }
  
  exec { "git clone $name":
    subscribe   => File[$name],
    command     => "/usr/bin/git clone '${from}' '${name}'",
    # onlyif this is NOT a valid git repository
    unless      => "bash -c '( cd \"$name\" && git status )'",
  }
  
}
