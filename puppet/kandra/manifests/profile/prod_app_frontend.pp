class kandra::profile::prod_app_frontend inherits kandra::profile::base {
  include kandra::app_frontend
  include doer::hooks::doer_notify

  Kandra::User_Dotfiles['root'] {
    keys => 'internal-limited-write-deploy-key',
  }
  Kandra::User_Dotfiles['doer'] {
    keys => 'internal-limited-write-deploy-key',
  }

  doer::sysctl { 'conntrack':
    comment => 'Increase conntrack kernel table size',
    key     => 'net.nf_conntrack_max',
    value   => zulipconf('application_server', 'conntrack_max', 262144),
  }

  file { '/etc/nginx/sites-available/doer':
    ensure  => file,
    require => [Package['nginx-full'], Exec['generate-default-snakeoil']],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/kandra/nginx/sites-available/doer',
    notify  => Service['nginx'],
  }

  file { '/etc/nginx/sites-enabled/doer':
    ensure  => link,
    require => Package['nginx-full'],
    target  => '/etc/nginx/sites-available/doer',
    notify  => Service['nginx'],
  }

  # Prod has our Apple Push Notifications Service private key at
  # /etc/ssl/django-private/apns-dist.pem
}
