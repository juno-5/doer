# @summary Install hook that notifies when a deploy starts/stops
#
class doer::hooks::doer_notify {
  include doer::hooks::base
  include doer::hooks::doer_common

  doer::hooks::file { [
    'pre-deploy.d/doer_notify.hook',
    'post-deploy.d/doer_notify.hook',
  ]: }
}
