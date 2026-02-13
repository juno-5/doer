class doer::localhost_sso {
  file { '/etc/nginx/doer-include/app.d/external-sso.conf':
    ensure  => file,
    require => Package[$doer::common::nginx],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['nginx'],
    source  => 'puppet:///modules/doer/nginx/doer-include-app.d/external-sso.conf',
  }
}
