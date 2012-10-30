class git( $ensure = present ) {
  
  package { git: ensure => $ensure }
  
}
