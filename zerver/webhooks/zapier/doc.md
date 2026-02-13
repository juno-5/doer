# Doer Zapier integration

Zapier supports integrations with
[hundreds of popular products](https://zapier.com/apps). Get notifications
sent by Zapier directly in Doer.

{start_tabs}

1. {!create-channel.md!}

1. {!create-an-incoming-webhook.md!}

1. Create an account on [Zapier](https://zapier.com). Go to [Doer
   Integrations][1], and select the app you want to connect to Doer.

1. Under **Choose a Trigger**, select an event in the app you are
   connecting to Doer. Under **Choose an Action**, select **Send a
   Private Message** or **Send a Stream Message**. Click **Connect**.

1. Follow the instructions in the right sidebar to set up the trigger
   event.

1. Select the Doer action in the center panel, and under **Account** in
   the right sidebar, click **Sign in** to connect your bot to Zapier.

1. On the **Allow Zapier to access your Doer Account** screen, enter
   the URL for your Doer organization, and the email address and API
   key of the bot you created above.

1. Under **Action** in the right sidebar, configure **Recipients** for
   direct messages, or **Stream name** and **Topic** for channel
   messages. Configure **Message content**.

    !!! tip ""
        To receive notifications as direct messages, if your email
        in Doer is [configured](/help/configure-email-visibility)
        to be visible to **Admins, moderators, members and guests**,
        enter the email associated with your Doer account in the
        **Recipients** field. Otherwise, enter `user` +
        [your user ID](/help/view-someones-profile) +
        `@` + your Doer domain, e.g., `user123@{{ display_host }}`.

1. Click **Publish** to enable your Zap.

{end_tabs}

[1]: https://zapier.com/apps/doer/integrations
