class kandra::prod_app_frontend_once {
  include doer::app_frontend_once
  include doer::hooks::push_git_ref
  include doer::hooks::doer_notify
  include kandra::hooks::doer_notify_schema_diff
  include kandra::mirror_to_czo

  doer::cron { 'update-first-visible-message-id':
    hour   => '7',
    minute => '0',
    manage => 'calculate_first_visible_message_id --lookback-hours 30',
  }

  doer::cron { 'invoice-plans':
    hour   => '22',
    minute => '0',
  }
  doer::cron { 'downgrade-small-realms-behind-on-payments':
    hour   => '17',
    minute => '0',
  }

  doer::cron { 'check_send_receive_time':
    hour      => '*',
    minute    => '*',
    command   => '/usr/lib/nagios/plugins/doer_app_frontend/check_send_receive_time',
    use_proxy => false,
  }
}
