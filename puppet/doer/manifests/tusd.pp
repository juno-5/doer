# @summary Provide the tusd service binary
#
class doer::tusd {
  $version = $doer::common::versions['tusd']['version']
  $bin = "/srv/zulip-tusd-${version}/tusd"

  # This tarball contains only a single file, which is extracted as $bin
  doer::external_dep { 'tusd':
    version        => $version,
    url            => "https://github.com/tus/tusd/releases/download/v${version}/tusd_linux_${doer::common::goarch}.tar.gz",
    tarball_prefix => "tusd_linux_${doer::common::goarch}",
    bin            => [$bin],
    cleanup_after  => [Service[supervisor]],
  }
  file { '/usr/local/bin/tusd':
    ensure  => link,
    target  => $bin,
    require => File[$bin],
    before  => Exec['Cleanup tusd'],
  }
}
