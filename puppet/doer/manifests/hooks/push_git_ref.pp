# @summary Push the merge_base to a git repo after deploy
#
class doer::hooks::push_git_ref {
  include doer::hooks::base

  doer::hooks::file { [
    'post-deploy.d/push_git_ref.hook',
  ]: }
}
