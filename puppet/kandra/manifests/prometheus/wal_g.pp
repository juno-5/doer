# @summary Prometheus monitoring of wal-g backups
#
class kandra::prometheus::wal_g {
  include kandra::prometheus::base
  include doer::supervisor
  include doer::wal_g

  file { '/usr/local/bin/wal-g-exporter':
    ensure  => file,
    require => User[doer],
    owner   => 'doer',
    group   => 'doer',
    mode    => '0755',
    source  => 'puppet:///modules/doer/postgresql/wal-g-exporter',
  }

  # We embed the hash of the contents into the name of the process, so
  # that `supervisorctl reread` knows that it has updated.
  $full_exporter_hash = sha256(file('doer/postgresql/wal-g-exporter'))
  $exporter_hash = $full_exporter_hash[0,8]
  file { "${doer::common::supervisor_conf_dir}/prometheus_wal_g_exporter.conf":
    ensure  => file,
    require => [
      User[doer],
      Package[supervisor],
      File['/usr/local/bin/wal-g-exporter'],
    ],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('kandra/supervisor/conf.d/prometheus_wal_g_exporter.conf.template.erb'),
    notify  => Service[supervisor],
  }
}
