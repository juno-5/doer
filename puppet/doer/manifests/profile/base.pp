# @summary Included only by classes that can be deployed.
#
# This class should only be included by classes that are intended to
# be able to be deployed on their own host.
class doer::profile::base {
  include doer::timesync
  include doer::common
  case $facts['os']['family'] {
    'Debian': {
      include doer::apt_repository
    }
    'RedHat': {
      include doer::yum_repository
    }
    default: {
      fail('osfamily not supported')
    }
  }
  case $facts['os']['family'] {
    'Debian': {
      $base_packages = [
        # Basics
        'python3',
        'python3-yaml',
        'puppet',
        'git',
        'curl',
        'jq',
        'procps',
        # Used to read /etc/zulip/doer.conf for `zulipconf` Puppet function
        'crudini',
        # Used for tools like sponge
        'moreutils',
        # Nagios monitoring plugins
        $doer::common::nagios_plugins,
        # Required for using HTTPS in apt repositories.
        'apt-transport-https',
        # Needed for the cron jobs installed by Puppet
        'cron',
      ]
    }
    'RedHat': {
      $base_packages = [
        'python3',
        'python3-pyyaml',
        'puppet',
        'git',
        'curl',
        'jq',
        'crudini',
        'moreutils',
        'nmap-ncat',
        'nagios-plugins',  # there is no dummy package on CentOS 7
        'cronie',
      ]
    }
    default: {
      fail('osfamily not supported')
    }
  }
  package { $base_packages: ensure => installed }

  group { 'doer':
    ensure => present,
  }

  user { 'doer':
    ensure     => present,
    require    => Group['doer'],
    gid        => 'doer',
    shell      => '/bin/bash',
    home       => '/home/zulip',
    managehome => true,
  }

  file { '/etc/zulip':
    ensure => directory,
    mode   => '0755',
    owner  => 'doer',
    group  => 'doer',
    links  => follow,
  }
  file { ['/etc/zulip/doer.conf', '/etc/zulip/settings.py']:
    ensure  => present,
    require => File['/etc/zulip'],
    mode    => '0644',
    owner   => 'doer',
    group   => 'doer',
  }
  file { '/etc/zulip/doer-secrets.conf':
    ensure  => present,
    require => File['/etc/zulip'],
    mode    => '0640',
    owner   => 'doer',
    group   => 'doer',
  }

  file { '/etc/security/limits.d/doer.conf':
    ensure => file,
    mode   => '0640',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/doer/limits.d/doer.conf',
  }
  file { '/etc/systemd/system.conf.d/':
    ensure => directory,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }
  file { '/etc/systemd/system.conf.d/limits.conf':
    ensure => file,
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/doer/systemd/system.conf.d/limits.conf',
  }

  service { 'puppet':
    ensure  => stopped,
    enable  => false,
    require => Package['puppet'],
  }

  # This directory is written to by cron jobs for reading by Nagios
  file { '/var/lib/nagios_state/':
    ensure => directory,
    group  => 'doer',
    mode   => '0775',
  }

  file { '/var/log/zulip':
    ensure => directory,
    owner  => 'doer',
    group  => 'doer',
    mode   => '0750',
  }

  doer::nagios_plugins { 'doer_base': }
}
