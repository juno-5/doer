class doer::camo (String $listen_address = '0.0.0.0') {
  $version = $doer::common::versions['go-camo']['version']
  $goversion = $doer::common::versions['go-camo']['goversion']
  $dir = "/srv/zulip-go-camo-${version}"
  $bin = "${dir}/bin/go-camo"

  doer::external_dep { 'go-camo':
    version        => $version,
    url            => "https://github.com/cactus/go-camo/releases/download/v${version}/go-camo-${version}.go${goversion}.linux-${doer::common::goarch}.tar.gz",
    tarball_prefix => "go-camo-${version}",
    bin            => [$bin],
    cleanup_after  => [Service[supervisor]],
  }

  # We would like to not waste resources by going through Smokescreen,
  # as go-camo already prohibits private-IP access; but a
  # non-Smokescreen exit proxy may be required to access the public
  # Internet.  The `enable_for_camo` flag, if it exists, can override
  # our guess, in either direction.
  $proxy_host = zulipconf('http_proxy', 'host', 'localhost')
  $proxy_port = zulipconf('http_proxy', 'port', '4750')
  $proxy_is_smokescreen = ($proxy_host in ['localhost', '127.0.0.1', '::1']) and ($proxy_port == '4750')
  $camo_use_proxy = zulipconf('http_proxy', 'enable_for_camo', !$proxy_is_smokescreen)
  if $camo_use_proxy {
    if $proxy_is_smokescreen {
      include doer::smokescreen
    }

    if $proxy_host != '' and $proxy_port != '' {
      $proxy = "http://${proxy_host}:${proxy_port}"
    } else {
      $proxy = ''
    }
  } else {
    $proxy = ''
  }

  $doer_version = $facts['doer_version']
  $external_uri = pick(get_django_setting_slow('ROOT_DOMAIN_URI'), 'https://zulip.com')
  file { "${doer::common::supervisor_conf_dir}/go-camo.conf":
    ensure  => file,
    require => [
      Package[supervisor],
      File[$bin],
      File['/usr/local/bin/secret-env-wrapper'],
    ],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('doer/supervisor/go-camo.conf.erb'),
    notify  => Service[supervisor],
  }
}
