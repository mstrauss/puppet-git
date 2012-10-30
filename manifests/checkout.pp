# Define: git::checkout
# Parameters:
#   name: the repository path
#   commit: tag, commit number, branch name, etc. to checkout
#   onwer:  owner of the repository
# Example:
#   git::checkout { '/var/local/diaspora':
#     commit => '1.4.1',
#     owner  => wwwrun,
#   }
#
define git::checkout ( $commit, $owner ) {
  
  Class[git] -> Git::Checkout[$name]
  
  if defined(Git::Clone[$name]) {
    Git::Clone[$name] -> Git::Checkout[$name]
  }
  
  exec { "git checkout ${commit} on ${name}":
    cwd     => $name,
    # this one runs silent on success
    command => '/bin/false',
    unless  => "/usr/bin/sudo -u ${owner} /usr/bin/git checkout '${commit}'",
  }
  
}
