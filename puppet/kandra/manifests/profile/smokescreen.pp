class kandra::profile::smokescreen inherits kandra::profile::base {


  include doer::profile::smokescreen
  kandra::firewall_allow { 'smokescreen': port => '4750' }
  kandra::firewall_allow { 'smokescreen_metrics': port => '4760' }

  include kandra::camo
}
