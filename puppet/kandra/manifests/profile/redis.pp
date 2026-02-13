class kandra::profile::redis inherits kandra::profile::base {
  include doer::profile::redis
  include kandra::prometheus::redis

  doer::sysctl { 'redis-somaxconn':
    key   => 'net.core.somaxconn',
    value => '65535',
  }

  # Need redis_password in its own file for Nagios
  file { '/var/lib/nagios/redis_password':
    ensure  => file,
    mode    => '0600',
    owner   => 'nagios',
    group   => 'nagios',
    content => "${doer::profile::redis::redis_password}\n",
  }

  group { 'redistunnel':
    ensure => present,
    gid    => '1080',
  }
  user { 'redistunnel':
    ensure     => present,
    uid        => '1080',
    gid        => '1080',
    groups     => ['doer'],
    shell      => '/bin/true',
    home       => '/home/redistunnel',
    managehome => true,
  }
  kandra::user_dotfiles { 'redistunnel':
    authorized_keys => true,
  }
}
