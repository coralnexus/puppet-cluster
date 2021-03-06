
#--------------------------------------------------------------------------------
# Defaults

corl_initialize()

#---

resources { "firewall":
  purge => true
}
Firewall {
  before  => Class['corl::firewall::post_rules'],
  require => Class['corl::firewall::pre_rules'],
}

include corl::params

Exec {
  user      => $corl::params::exec_user,
  path      => $corl::params::exec_path,
  logoutput => 'on_failure'
}

#--------------------------------------------------------------------------------
# Gateway

node default {
  
  anchor { 'gateway_init': }
  
  #-----------------------------------------------------------------------------
  # Initialization 

  class { 'corl': require => Anchor['gateway_init'] }
  include corl::firewall::pre_rules
  include corl::firewall::post_rules

  # Attach profiles here...
  anchor { 'profile_start': require => Class['corl'] }
}
