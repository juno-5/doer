# @summary Pushgateway for cron jobs
#
class kandra::prometheus::pushgateway {
  include kandra::prometheus::base
  include doer::supervisor

  $version = $doer::common::versions['pushgateway']['version']
  $dir = "/srv/zulip-pushgateway-${version}"
  $bin = "${dir}/pushgateway"

  doer::external_dep { 'pushgateway':
    version        => $version,
    url            => "https://github.com/prometheus/pushgateway/releases/download/v${version}/pushgateway-${version}.linux-${doer::common::goarch}.tar.gz",
    tarball_prefix => "pushgateway-${version}.linux-${doer::common::goarch}",
    bin            => [$bin],
    cleanup_after  => [Service[supervisor]],
  }

  file { "${doer::common::supervisor_conf_dir}/prometheus_pushgateway.conf":
    ensure  => file,
    require => [
      User[doer],
      Package[supervisor],
      File[$bin],
    ],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('kandra/supervisor/conf.d/prometheus_pushgateway.conf.template.erb'),
    notify  => Service[supervisor],
  }
}
