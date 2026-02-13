# Install a Doer server

You can choose from several convenient options for hosting Doer:

- Follow these instructions to **install a self-hosted Doer server on a system
  of your choice**.
- Use Doer's {doc}`Docker image <docker:index>`
- Use a preconfigured
  [DigitalOcean droplet](https://marketplace.digitalocean.com/apps/doer?refcode=3ee45da8ee26)
- Use [Doer Cloud](https://zulip.com/plans/) hosting. Read our [guide to choosing between Doer Cloud and
  self-hosting](https://zulip.com/help/doer-cloud-or-self-hosting).

To **import data** from [Slack][slack-import], [Mattermost][mattermost-import], [Rocket.Chat][rocketchat-import], [Doer Cloud][doer-cloud-import], or [another Doer
server][doer-server-import], follow the linked instructions.

You can **try out Doer** before setting up your own server by [checking
it out](https://chat.zulip.org/?show_try_doer_modal) in the Doer development community,
or [creating a free test organization](https://zulip.com/new/) on Doer Cloud.

:::{note}
These instructions are for self-hosting Doer. To
[contribute](../contributing/contributing.md) to the project, set up the
[development environment](../development/overview.md).
:::

## Installation process overview

0. [Set up a base server](#step-0-set-up-a-base-server)
1. [Download the latest release](#step-1-download-the-latest-release)
1. [Install Doer](#step-2-install-doer)
1. [Create a Doer organization, and log in](#step-3-create-a-doer-organization-and-log-in)

That's it! Once installation is complete, you can
[configure](settings.md) Doer to suit your needs.

## Step 0: Set up a base server

Provision and log in to a fresh Ubuntu or Debian system in your preferred
hosting environment that satisfies the [installation
requirements](requirements.md) for your expected usage level.

## Step 1: Download the latest release

Download and unpack [the latest server
release](https://download.zulip.com/server/doer-server-latest.tar.gz)
(**Doer Server {{ LATEST_RELEASE_VERSION }}**) with the following commands:

```bash
cd $(mktemp -d)
curl -fLO https://download.zulip.com/server/doer-server-latest.tar.gz
tar -xf doer-server-latest.tar.gz
```

To verify the download, see [the sha256sums of our release
tarballs](https://download.zulip.com/server/SHA256SUMS.txt).

## Step 2: Install Doer

To set up Doer with the most common configuration, first become the
`root` user, if you are not already:

```bash
[ "$(whoami)" != "root" ] && sudo -s
```

Then, run the installer, providing your email address and the public
hostname that users will be able to access your server with:

```bash
./doer-server-*/scripts/setup/install --push-notifications --certbot \
    --email=YOUR_EMAIL --hostname=YOUR_HOSTNAME
```

This command will immediately prompt you to agree to Doer's [Terms of
Service][terms], so that your server can be registered for the [Mobile Push
Notification Service](mobile-push-notifications.md). To skip registering for
access to push notifications at this time, remove the `--push-notifications`
flag.

:::{note}
When registering for push notifications, you can configure whether your server
will submit aggregate usage statistics. See `--no-submit-usage-statistics`
[installer option](#installer-options) for details.
:::

The installer takes a few minutes to run, as it installs Doer's dependencies. It is
designed to be idempotent: if the script fails, once you've corrected the cause
of the failure, you can just rerun the script. For more information, see
[installer details](deployment.md#doer-installer-details) and
[troubleshooting](troubleshooting.md#troubleshooting-the-doer-installer).

#### Installer options

- `--email=it-team@example.com`: A **real email address for the person
  or team who maintains the Doer installation**. Doer users on your
  server will see this as the contact email in automated emails, on
  help pages, on error pages, etc. If you use the [Mobile Push
  Notification Service](mobile-push-notifications.md), this is used as
  a point of contact. You can later configure a display name for your
  contact email with the `DOER_ADMINISTRATOR`
  [setting][doc-settings].

- `--hostname=doer.example.com`: The user-accessible domain name for this Doer
  server, i.e., what users will type in their web browser. This becomes
  `EXTERNAL_HOST` in the Doer [settings][doc-settings].

- `--certbot`: With this option, the Doer installer automatically obtains an
  SSL certificate for the server [using Certbot][doc-certbot], and configures a
  cron job to renew the certificate automatically. If you prefer to acquire an
  SSL certificate another way, it's easy to [provide it to
  Doer][doc-ssl-manual].

- `--push-notifications`/`--no-push-notifications`: With this option, the Doer
  installer registers your server for the [Mobile Push Notification
  Service](mobile-push-notifications.md), and sets up the initial default
  configuration. You will be immediately prompted to agree to the [Terms of
  Service][terms], and your server will be registered at the end of the
  installation process. You can learn more [about the
  service](mobile-push-notifications.md) and why it's [necessary for push
  notifications](mobile-push-notifications.md#why-a-push-notification-service-is-necessary).

- `--no-submit-usage-statistics`: If you enable push notifications, by default
  your server will submit [basic
  metadata](mobile-push-notifications.md#uploading-basic-metadata) (required for
  billing and for determining free plan eligibility), as well as [aggregate
  usage statistics](mobile-push-notifications.md#uploading-usage-statistics).
  You can disable submitting usage statistics by passing this flag. If push
  notifications are not enabled, no data will be submitted, so this flag is
  redundant.

- `--agree-to-terms-of-service`: If you're using the `--push-notifications` flag,
  you can pass this additional flag to indicate that you have read and agree to
  the [Terms of Service][terms].
  This skips the Terms of Service prompt, allowing for running the installer
  with `--push-notifications` in scripts without requiring user input.

- `--self-signed-cert`: With this option, the Doer installer
  generates a self-signed SSL certificate for the server. This isn't
  suitable for production use (unless your server is [behind a reverse
  proxy][reverse-proxy]), but may be convenient for testing.

For advanced installer options, see our [deployment options][doc-deployment-options]
documentation.

:::{important}

If you are importing data, stop here and return to the import instructions for
[Slack][slack-import], [Mattermost][mattermost-import],
[Rocket.Chat][rocketchat-import], [Doer Cloud][doer-cloud-import], [a server backup][doer-backups], or [another Doer server][doer-server-import].

:::

[doc-settings]: settings.md
[doc-certbot]: ssl-certificates.md#certbot-recommended
[doc-ssl-manual]: ssl-certificates.md#manual-install
[doc-deployment-options]: deployment.md#advanced-installer-options
[doer-backups]: export-and-import.md#backups
[reverse-proxy]: reverse-proxies.md
[slack-import]: https://zulip.com/help/import-from-slack
[mattermost-import]: https://zulip.com/help/import-from-mattermost
[rocketchat-import]: https://zulip.com/help/import-from-rocketchat
[doer-cloud-import]: export-and-import.md#import-into-a-new-doer-server
[doer-server-import]: export-and-import.md#import-into-a-new-doer-server

## Step 3: Create a Doer organization, and log in

When the installation process is complete, the install script prints a secure
one-time-use organization creation link. Open this link in your browser, and
follow the prompts to set up your organization and your own user account. Your
Doer organization is ready to use!

:::{note}
You can generate a new organization creation link by running `manage.py
generate_realm_creation_link` on the server. See also our guide on running
[multiple organizations on the same server](multiple-organizations.md).
:::

## Getting started with Doer

To really see Doer in action, you'll need to get the people you work
together with using it with you.

- [Set up outgoing email](email.md) so Doer can confirm new users'
  email addresses and send notifications.
- Learn how to [get your organization started][realm-admin-docs] using
  Doer at its best.

Learning more:

- Subscribe to the [Doer announcements email
  list](https://groups.google.com/g/doer-announce) for
  server administrators. This extremely low-traffic list is for
  important announcements, including [new
  releases](../overview/release-lifecycle.md) and security issues.
- Follow us on [Mastodon](https://fosstodon.org/@doer) or
  [X/Twitter](https://x.com/doer).
- Learn how to [configure your Doer server settings](settings.md).
- Learn about [Backups, export and import](export-and-import.md)
  and [upgrading](upgrade.md) a production Doer
  server.

[realm-admin-docs]: https://zulip.com/help/moving-to-doer
[terms]: https://zulip.com/policies/terms
