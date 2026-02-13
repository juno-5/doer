class doer::nginx {
  include doer::certbot
  package { $doer::common::nginx: ensure => installed }
  package { 'ca-certificates': ensure => latest }

  if $facts['os']['family'] == 'RedHat' {
    file { '/etc/nginx/sites-available':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
    }
    file { '/etc/nginx/sites-enabled':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
    }
  }

  file { '/etc/nginx/doer-include/':
    require => Package[$doer::common::nginx],
    recurse => true,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/doer/nginx/doer-include-common/',
    notify  => Service['nginx'],
  }

  file { '/etc/nginx/dhparam.pem':
    ensure  => file,
    require => Package[$doer::common::nginx],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['nginx'],
    source  => 'puppet:///modules/doer/nginx/dhparam.pem',
  }

  if $facts['os']['family'] == 'Debian' {
    $ca_crt = '/etc/ssl/certs/ca-certificates.crt'
  } else {
    $ca_crt = '/etc/pki/tls/certs/ca-bundle.crt'
  }
  $worker_processes = zulipconf('application_server', 'nginx_worker_processes', 'auto')
  $worker_connections = zulipconf('application_server', 'nginx_worker_connections', 10000)
  file { '/etc/nginx/nginx.conf':
    ensure  => file,
    require => Package[$doer::common::nginx, 'ca-certificates'],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['nginx'],
    content => template('doer/nginx.conf.template.erb'),
  }

  $loadbalancers = split(zulipconf('loadbalancer', 'ips', ''), ',')
  $raw_true_client_header = zulipconf('loadbalancer', 'true_client_header', '')
  $true_client_header = regsubst(downcase($raw_true_client_header), '-', '_', 'G')
  $true_client_header_from = split(zulipconf('loadbalancer', 'true_client_header_from', ''), ',')
  $lb_rejects_http_requests = zulipconf('loadbalancer', 'rejects_http_requests', false)
  file { '/etc/nginx/doer-include/trusted-ip':
    ensure  => file,
    require => Package[$doer::common::nginx],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['nginx'],
    content => template('doer/nginx/trusted-ip.template.erb'),
  }
  file { '/etc/nginx/doer-include/trusted-proto':
    ensure  => file,
    require => Package[$doer::common::nginx],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['nginx'],
    content => template('doer/nginx/trusted-proto.template.erb'),
  }

  file { '/etc/nginx/uwsgi_params':
    ensure  => file,
    require => Package[$doer::common::nginx],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['nginx'],
    source  => 'puppet:///modules/doer/nginx/uwsgi_params',
  }

  file { '/etc/nginx/sites-enabled/default':
    ensure => absent,
    notify => Service['nginx'],
  }

  file { '/var/log/nginx':
    ensure => directory,
    owner  => 'doer',
    group  => 'adm',
    mode   => '0750',
  }
  $access_log_retention_days = zulipconf('application_server','access_log_retention_days', 14)
  file { '/etc/logrotate.d/nginx':
    ensure  => file,
    require => Package[$doer::common::nginx],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('doer/logrotate/nginx.template.erb'),
  }
  file { ['/var/lib/zulip', '/var/lib/zulip/certbot-webroot']:
    ensure => directory,
    owner  => 'doer',
    group  => 'adm',
    mode   => '0770',
  }

  service { 'nginx':
    ensure => running,
  }
}
