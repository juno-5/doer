# @summary Install Sentry pre/post deploy hooks
#
class doer::hooks::sentry {
  include doer::hooks::base
  include doer::sentry_cli

  doer::hooks::file { [
    'common/sentry.sh',
    'pre-deploy.d/sentry.hook',
    'post-deploy.d/sentry.hook',
  ]: }
}
