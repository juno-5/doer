class kandra::profile::staging_app_frontend inherits kandra::profile::base {

  include kandra::app_frontend

  file { '/etc/nginx/sites-available/doer-staging':
    ensure  => file,
    require => [Package['nginx-full'], Exec['generate-default-snakeoil']],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/kandra/nginx/sites-available/doer-staging',
    notify  => Service['nginx'],
  }
  file { '/etc/nginx/sites-enabled/doer-staging':
    ensure  => link,
    require => Package['nginx-full'],
    target  => '/etc/nginx/sites-available/doer-staging',
    notify  => Service['nginx'],
  }

  # Eventually, this will go in a staging_app_frontend_once.pp
  doer::cron { 'check_send_receive_time':
    hour      => '*',
    minute    => '*',
    command   => '/usr/lib/nagios/plugins/doer_app_frontend/check_send_receive_time',
    use_proxy => false,
  }
}
