# @summary Send zuip update announcements after deploy
#
class doer::hooks::send_doer_update_announcements {
  include doer::hooks::base

  doer::hooks::file { [
    'post-deploy.d/send_doer_update_announcements.hook',
  ]: }
}
