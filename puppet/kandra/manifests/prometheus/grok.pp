# @summary Parses nginx access_log files
#
class kandra::prometheus::grok {
  include kandra::prometheus::base
  include doer::supervisor

  $version = $doer::common::versions['grok_exporter']['version']
  $dir = "/srv/zulip-grok_exporter-${version}"
  $bin = "${dir}/grok_exporter"

  doer::external_dep { 'grok_exporter':
    version        => $version,
    url            => "https://github.com/fstab/grok_exporter/releases/download/v${version}/grok_exporter-${version}.linux-${doer::common::goarch}.zip",
    tarball_prefix => "grok_exporter-${version}.linux-${doer::common::goarch}",
    bin            => [$bin],
    cleanup_after  => [Service[supervisor]],
  }

  $realm_names_regex = zulipconf('grok_exporter', 'realm_names_regex', '__impossible__')
  $include_dir = "${dir}/patterns"
  file { '/etc/grok_exporter.yaml':
    ensure  => file,
    owner   => doer,
    group   => doer,
    mode    => '0644',
    content => template('kandra/prometheus/grok_exporter.yaml.template.erb'),
    notify  => Service[supervisor],
  }

  kandra::firewall_allow { 'grok_exporter': port => '9144' }
  file { "${doer::common::supervisor_conf_dir}/prometheus_grok_exporter.conf":
    ensure  => file,
    require => [
      User[doer],
      Package[supervisor],
      File[$bin],
      File['/etc/grok_exporter.yaml'],
    ],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('kandra/supervisor/conf.d/prometheus_grok_exporter.conf.template.erb'),
    notify  => Service[supervisor],
  }
}
