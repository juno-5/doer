# @summary Install a static hook file
#
define kandra::hooks::file() {
  include doer::hooks::base

  file { "/etc/zulip/hooks/${title}":
    ensure => file,
    mode   => '0755',
    owner  => 'doer',
    group  => 'doer',
    source => "puppet:///modules/kandra/hooks/${title}",
    tag    => ['hooks'],
  }
}
