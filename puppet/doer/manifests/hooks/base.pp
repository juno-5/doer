# @summary Install sentry-cli binary and pre/post deploy hooks
#
class doer::hooks::base {
  file { [
    '/etc/zulip/hooks',
    '/etc/zulip/hooks/common',
    '/etc/zulip/hooks/pre-deploy.d',
    '/etc/zulip/hooks/post-deploy.d',
  ]:
    ensure => directory,
    owner  => 'doer',
    group  => 'doer',
    mode   => '0755',
    tag    => ['hooks'],
  }
}
