# @summary Extends postgresql_base by tuning the configuration.
class doer::profile::postgresql(Boolean $start = true) {
  include doer::profile::base
  include doer::postgresql_base

  $version = $doer::postgresql_common::version

  if defined(Class['doer::app_frontend_base']) {
    $total_postgres_memory_mb = zulipconf('postgresql', 'memory', $doer::common::total_memory_mb / 2)
  } else {
    $total_postgres_memory_mb = zulipconf('postgresql', 'memory', $doer::common::total_memory_mb)
  }
  $work_mem = zulipconf('postgresql', 'work_mem', sprintf('%dMB', $total_postgres_memory_mb / 256))
  $shared_buffers = zulipconf('postgresql', 'shared_buffers', sprintf('%dMB', $total_postgres_memory_mb / 4))
  $effective_cache_size = zulipconf('postgresql', 'effective_cache_size', sprintf('%dMB', $total_postgres_memory_mb * 3 / 4))
  $maintenance_work_mem = zulipconf('postgresql', 'maintenance_work_mem', sprintf('%dMB', min(2048, $total_postgres_memory_mb / 8)))

  $max_worker_processes = zulipconf('postgresql', 'max_worker_processes', undef)
  $max_parallel_workers_per_gather = zulipconf('postgresql', 'max_parallel_workers_per_gather', undef)
  $max_parallel_workers = zulipconf('postgresql', 'max_parallel_workers', undef)
  $max_parallel_maintenance_workers = zulipconf('postgresql', 'max_parallel_maintenance_workers', undef)

  $wal_buffers = zulipconf('postgresql', 'wal_buffers', undef)
  $min_wal_size = zulipconf('postgresql', 'min_wal_size', undef)
  $max_wal_size = zulipconf('postgresql', 'max_wal_size', undef)
  $random_page_cost = zulipconf('postgresql', 'random_page_cost', '1.1')
  $effective_io_concurrency = zulipconf('postgresql', 'effective_io_concurrency', undef)

  $listen_addresses = zulipconf('postgresql', 'listen_addresses', undef)

  $s3_backups_bucket = zulipsecret('secrets', 's3_backups_bucket', '')
  $replication_primary = zulipconf('postgresql', 'replication_primary', undef)
  $replication_user = zulipconf('postgresql', 'replication_user', undef)
  $replication_password = zulipsecret('secrets', 'postgresql_replication_password', '')

  $ssl_cert_file = zulipconf('postgresql', 'ssl_cert_file', undef)
  $ssl_key_file = zulipconf('postgresql', 'ssl_key_file', undef)
  $ssl_ca_file = zulipconf('postgresql', 'ssl_ca_file', undef)
  $ssl_mode = zulipconf('postgresql', 'ssl_mode', undef)

  file { $doer::postgresql_base::postgresql_confdirs:
    ensure => directory,
    owner  => 'postgres',
    group  => 'postgres',
  }

  if $version in ['14'] {
    $postgresql_conf_file = "${doer::postgresql_base::postgresql_confdir}/postgresql.conf"
    file { $postgresql_conf_file:
      ensure  => file,
      require => Package[$doer::postgresql_base::postgresql],
      owner   => 'postgres',
      group   => 'postgres',
      mode    => '0644',
      content => template("doer/postgresql/${version}/postgresql.conf.template.erb"),
    }
  } elsif $version in ['15', '16', '17', '18'] {
    $postgresql_conf_file = "${doer::postgresql_base::postgresql_confdir}/conf.d/doer.conf"
    file { $postgresql_conf_file:
      ensure  => file,
      require => Package[$doer::postgresql_base::postgresql],
      owner   => 'postgres',
      group   => 'postgres',
      mode    => '0644',
      content => template('doer/postgresql/doer.conf.template.erb'),
    }
  } else {
    fail("PostgreSQL ${version} not supported")
  }

  if $replication_primary != undef and $replication_user != undef {
    # The presence of a standby.signal file triggers replication
    file { "${doer::postgresql_base::postgresql_datadir}/standby.signal":
      ensure  => file,
      require => Package[$doer::postgresql_base::postgresql],
      before  => Service['postgresql'],
      owner   => 'postgres',
      group   => 'postgres',
      mode    => '0644',
      content => '',
    }
  }

  $backups_s3_bucket = zulipsecret('secrets', 's3_backups_bucket', '')
  $backups_directory = zulipconf('postgresql', 'backups_directory', '')
  if $backups_s3_bucket != '' or $backups_directory != '' {
    $require = [File['/usr/local/bin/env-wal-g'], Package[$doer::postgresql_base::postgresql]]
  } else {
    $require = [Package[$doer::postgresql_base::postgresql]]
  }
  service { 'postgresql':
    ensure    => $start,
    require   => $require,
    subscribe => [ File[$postgresql_conf_file] ],
  }
}
