class doer::local_mailserver {
  include doer::snakeoil
  include doer::certbot

  if zulipconf('postfix', 'uninstall', true) {
    package { 'postfix':
      # TODO/compatibility: We can remove this when upgrading directly
      # from 10.x is no longer possible.  We do not use "purged" here,
      # since that would remove config files, which users may have had
      # installed.
      ensure => absent,
      before => Service[$doer::common::supervisor_service],
    }
  }
  file { "${doer::common::supervisor_conf_dir}/email-mirror.conf":
    ensure  => file,
    require => [
      Package[supervisor],
    ],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('doer/supervisor/email-mirror.conf.template.erb'),
    notify  => Service[$doer::common::supervisor_service],
  }
  file { '/etc/letsencrypt/renewal-hooks/deploy/055-email-server.sh':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/doer/letsencrypt/055-email-server.sh',
  }
}
