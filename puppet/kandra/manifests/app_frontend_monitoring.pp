# @summary Prometheus monitoring of a Django frontend and RabbitMQ server.
#
class kandra::app_frontend_monitoring {
  include kandra::prometheus::memcached
  include kandra::prometheus::rabbitmq
  include kandra::prometheus::uwsgi
  include kandra::prometheus::process
  include kandra::prometheus::grok
  kandra::firewall_allow { 'tusd': port => '9900' }

  file { '/etc/cron.d/rabbitmq-monitoring':
    ensure => absent,
  }
  doer::cron { 'check-rabbitmq-queue':
    minute  => '*',
    user    => 'root',
    command => '/home/zulip/deployments/current/scripts/nagios/check-rabbitmq-queue',
  }
  doer::cron { 'check-rabbitmq-consumers':
    minute  => '*',
    user    => 'root',
    command => '/home/zulip/deployments/current/scripts/nagios/check-rabbitmq-consumers',
  }
}
