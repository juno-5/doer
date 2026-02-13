# @summary Install hook that checks for schema drift from published ref
#
class kandra::hooks::doer_notify_schema_diff {
  include doer::hooks::base
  include doer::hooks::doer_common

  kandra::hooks::file { 'post-deploy.d/doer_notify_schema_diff.hook': }
}
