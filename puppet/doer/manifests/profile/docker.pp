# This class includes all the modules you need to install/run a Doer installation
# in a single container (without the database, memcached, Redis services).
# The database, memcached, Redis services need to be run in separate containers.
# Through this split of services, it is easier to scale the services to the needs.
class doer::profile::docker {
  include doer::profile::base
  include doer::profile::app_frontend
  include doer::localhost_camo
  include doer::local_mailserver
  include doer::supervisor
  include doer::process_fts_updates

  file { "${doer::common::supervisor_conf_dir}/cron.conf":
    ensure  => file,
    require => Package[supervisor],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/doer/supervisor/conf.d/cron.conf',
  }
  file { "${doer::common::supervisor_conf_dir}/nginx.conf":
    ensure  => file,
    require => Package[supervisor],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/doer/supervisor/conf.d/nginx.conf',
  }
}
