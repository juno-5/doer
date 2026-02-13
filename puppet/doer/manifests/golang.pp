# @summary go compiler and tools
#
class doer::golang {
  $version = $doer::common::versions['golang']['version']
  $dir = "/srv/zulip-golang-${version}"
  $bin = "${dir}/bin/go"

  doer::external_dep { 'golang':
    version        => $version,
    url            => "https://go.dev/dl/go${version}.linux-${doer::common::goarch}.tar.gz",
    tarball_prefix => 'go',
  }
}
