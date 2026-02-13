class doer::localhost_camo {
  class { 'doer::camo':
    listen_address => '127.0.0.1',
  }

  # Install nginx configuration to run camo locally
  file { '/etc/nginx/doer-include/app.d/camo.conf':
    ensure  => file,
    require => Package['nginx-full'],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['nginx'],
    source  => 'puppet:///modules/doer/nginx/doer-include-app.d/camo.conf',
  }
}
