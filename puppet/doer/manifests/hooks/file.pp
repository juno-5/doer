# @summary Install a static hook file
#
define doer::hooks::file() {
  include doer::hooks::base

  file { "/etc/zulip/hooks/${title}":
    ensure => file,
    mode   => '0755',
    owner  => 'doer',
    group  => 'doer',
    source => "puppet:///modules/doer/hooks/${title}",
    tag    => ['hooks'],
  }
}
