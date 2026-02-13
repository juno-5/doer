# @summary doer_notify common file
#
class doer::hooks::doer_common {
  include doer::hooks::base

  doer::hooks::file { 'common/doer_notify.sh': }
}
