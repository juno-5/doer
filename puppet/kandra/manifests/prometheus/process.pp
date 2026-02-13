# @summary Prometheus monitoring of Doer server processes
#
class kandra::prometheus::process {
  include kandra::prometheus::base
  include doer::supervisor

  $version = $doer::common::versions['process_exporter']['version']
  $dir = "/srv/zulip-process_exporter-${version}"
  $bin = "${dir}/process-exporter"
  $conf = '/etc/zulip/process_exporter.yaml'

  doer::external_dep { 'process_exporter':
    version        => $version,
    url            => "https://github.com/ncabatoff/process-exporter/releases/download/v${version}/process-exporter-${version}.linux-${doer::common::goarch}.tar.gz",
    tarball_prefix => "process-exporter-${version}.linux-${doer::common::goarch}",
    bin            => [$bin],
    cleanup_after  => [Service[supervisor]],
  }

  kandra::firewall_allow { 'process_exporter': port => '9256' }
  file { $conf:
    ensure  => file,
    require => User[doer],
    owner   => 'doer',
    group   => 'doer',
    mode    => '0644',
    source  => 'puppet:///modules/kandra/process_exporter.yaml',
  }
  file { "${doer::common::supervisor_conf_dir}/prometheus_process_exporter.conf":
    ensure  => file,
    require => [
      User[doer],
      Package[supervisor],
      File[$bin],
      File[$conf],
    ],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('kandra/supervisor/conf.d/prometheus_process_exporter.conf.template.erb'),
    notify  => Service[supervisor],
  }
}
