# @summary Installs a subdirectory from puppet/doer/files/nagios_plugins/
define doer::nagios_plugins () {
  include doer::common

  file { "${doer::common::nagios_plugins_dir}/${name}":
    require => Package[$doer::common::nagios_plugins],
    recurse => true,
    purge   => true,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => "puppet:///modules/doer/nagios_plugins/${name}",
  }
}
