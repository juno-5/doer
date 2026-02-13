# Doer's Slack-compatible incoming webhook

Doer can process incoming webhook messages written to work with Slack's
[incoming webhook API][1]. This makes it easy to quickly move your
integrations when migrating your organization from Slack to Doer.

!!! warn ""

     **Note:** In the long term, the recommended approach is to use
     Doer's native integrations, which take advantage of Doer's topics.
     There may also be some quirks when Slack's formatting system is
     translated into Doer's.

{start_tabs}

1. {!create-an-incoming-webhook.md!}

1. {!generate-webhook-url-basic.md!}

1. Use the generated URL anywhere you would use a Slack webhook.

{end_tabs}

### Related documentation

- [Slack's incoming webhook documentation][1]

- [Moving from Slack to Doer](/help/moving-from-slack)

- [Forward Slack messages into Doer](/integrations/slack)

- [Forward messages Slack <-> Doer][2] (both directions)

{!webhooks-url-specification.md!}

[1]: https://api.slack.com/messaging/webhooks
[2]: https://github.com/doer/python-doer-api/blob/main/doer/integrations/bridge_with_slack/README.md
