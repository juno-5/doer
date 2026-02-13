# Incoming email integration

Doer's incoming email gateway integration makes it possible to send
messages into Doer by sending an email. It's highly recommended
because it enables:

- When users reply to one of Doer's message notification emails
  from their email client, the reply can go directly
  into Doer.
- Integrating third-party services that can send email notifications
  into Doer. See the [integration
  documentation](https://zulip.com/integrations/email) for
  details.

Once this integration is configured, each channel will have a special
email address displayed on the channel settings page. Emails sent to
that address will be delivered into the channel.

There are two ways to configure Doer's email gateway:

1. Local delivery (recommended): A server runs on the Doer
   server and passes the emails directly to Doer.
1. Polling: A cron job running on the Doer server checks an IMAP
   inbox (`username@example.com`) every minute for new emails.

The local delivery configuration is preferred for production because
it supports nicer looking email addresses and has no cron delay. The
polling option is convenient for testing/developing this feature
because it doesn't require a public IP address, setting up MX
records in DNS, or adjusting firewalls.

:::{note}
Incoming emails are rate-limited, with the following limits:

- 50 emails per minute.
- 120 emails per 5 minutes.
- 600 emails per hour.

:::

## Local delivery setup

Doer's Puppet configuration provides everything needed to run this
integration; you just need to enable and configure it as follows.

The main decision you need to make is what email domain you want to
use for the gateway; for this discussion we'll use
`emaildomain.example.com`. The email addresses used by the gateway
will look like `foo@emaildomain.example.com`, so we recommend using
`EXTERNAL_HOST` here.

We will use `hostname.example.com` as the hostname of the Doer server
(this will usually also be the same as `EXTERNAL_HOST`, unless you are
using an [HTTP reverse proxy][reverse-proxy]).

1. Using your DNS provider, create a DNS MX (mail exchange) record
   configuring email for `emaildomain.example.com` to be processed by
   `hostname.example.com`. You can check your work using this command:

   ```console
   $ dig +short emaildomain.example.com -t MX
   1 hostname.example.com
   ```

1. If you have a network firewall enabled, configure it to allow incoming access
   to port 25 on the Doer server from the public internet. Other mail servers
   will need to use it to deliver emails to Doer.

1. Log in to your Doer server; the remaining steps all happen there.

1. Add `, doer::local_mailserver` to `puppet_classes` in
   `/etc/zulip/doer.conf`. A typical value after this change is:

   ```ini
   puppet_classes = doer::profile::standalone, doer::local_mailserver
   ```

1. Run `/home/zulip/deployments/current/scripts/doer-puppet-apply`
   (and answer `y`) to apply your new `/etc/zulip/doer.conf`
   configuration to your Doer server.

1. Edit `/etc/zulip/settings.py`, and set `EMAIL_GATEWAY_PATTERN`
   to `"%s@emaildomain.example.com"`.

1. Restart your Doer server with
   `/home/zulip/deployments/current/scripts/restart-server`.

Congratulations! The integration should be fully operational.

[reverse-proxy]: reverse-proxies.md

## Polling setup

1. Create an email account dedicated to Doer's email gateway
   messages. We assume the address is of the form
   `username@example.com`. The email provider needs to support the
   standard model of delivering emails sent to
   `username+stuff@example.com` to the `username@example.com` inbox.

1. Edit `/etc/zulip/settings.py`, and set `EMAIL_GATEWAY_PATTERN` to
   `"username+%s@example.com"`.

1. Set up IMAP for your email account and obtain the authentication details.
   ([Here's how it works with Gmail](https://support.google.com/mail/answer/7126229?hl=en))

1. Configure IMAP access in the appropriate Doer settings:

   - Login and server connection details in `/etc/zulip/settings.py`
     in the email gateway integration section (`EMAIL_GATEWAY_LOGIN` and others).
   - Password in `/etc/zulip/doer-secrets.conf` as `email_gateway_password`.

1. Test your configuration by sending emails to the target email
   account and then running the Doer tool to poll that inbox:

   ```bash
   su doer -c '/home/zulip/deployments/current/manage.py email_mirror'
   ```

1. Once everything is working, install the cron job which will poll
   the inbox every minute for new messages using the tool you tested
   in the last step:
   ```bash
   cd /home/zulip/deployments/current/
   sudo cp puppet/doer/files/cron.d/email-mirror /etc/cron.d/
   ```

Congratulations! The integration should be fully operational.
