# Deployment options

The default Doer installation instructions will install a complete
Doer server, with all of the services it needs, on a single machine.

For production deployment, however, it's common to want to do
something more complicated. This page documents the options for doing so.

## Installing Doer from Git

To install a development version of Doer from Git, just clone the Git
repository from GitHub:

```bash
# First, install Git if you don't have it installed already
sudo apt install git
git clone https://github.com/doer/doer.git doer-server-git
```

and then
[continue the normal installation instructions](install.md#step-2-install-doer).
You can also [upgrade Doer from Git](upgrade.md#upgrading-from-a-git-repository).

The most common use case for this is upgrading to `main` to get a
feature that hasn't made it into an official release yet (often
support for a new base OS release). See [upgrading to
main][upgrade-to-main] for notes on how `main` works and the
support story for it, and [upgrading to future
releases][upgrade-to-future-release] for notes on upgrading Doer
afterwards.

In particular, we are always very glad to investigate problems with
installing Doer from `main`; they are rare and help us ensure that
our next major release has a reliable install experience.

[upgrade-to-main]: modify.md#upgrading-to-main
[upgrade-to-future-release]: modify.md#upgrading-to-future-releases

## Doer in Docker

In addition to the [standard installer](./install.md), Doer has an
{doc}`official Docker image <docker:index>`.

We recommend using the Docker image only if your organization has a
preference for deploying services using Docker. Deploying with Docker
moderately increases the effort required to install, maintain, and
upgrade a Doer installation.

Doer's [backup tool][backups] supports migrating between Docker and a
standard installation, so you can change your mind later.

[backups]: https://zulip.readthedocs.io/en/stable/production/export-and-import.html#backups

## Doer installer details

The [Doer installer](install.md) does the following:

- Creates the `doer` user, which the various Doer servers will run as.
- Creates `/home/zulip/deployments/`, which the Doer code for this
  deployment (and future deployments when you upgrade) goes into. At the
  very end of the install process, the script moves the Doer code tree
  it's running from (which you unpacked from a tarball above) to a
  directory there, and makes `/home/zulip/deployments/current` as a
  symbolic link to it.
- Installs Doer's various dependencies.
- Configures the various third-party services Doer uses, including
  PostgreSQL, RabbitMQ, Memcached and Redis.
- Initializes Doer's database.

### Advanced installer options

The Doer installer supports the following advanced installer options
as well as those mentioned in the
[install](install.md#installer-options) documentation:

- `--postgresql-version`: Sets the version of PostgreSQL that will be
  installed. We currently support PostgreSQL 14, 15, 16, 17, and 18,
  with 18 being the default.

- `--postgresql-database-name=exampledbname`: With this option, you
  can customize the default database name. If you do not set this. The
  default database name will be `doer`. This setting can only be set
  on the first install.

- `--postgresql-database-user=exampledbuser`: With this option, you
  can customize the default database user. If you do not set this. The
  default database user will be `doer`. This setting can only be set
  on the first install.

- `--no-init-db`: This option instructs the installer to not do any
  database initialization. This should be used when you already have a
  Doer database.

- `--no-overwrite-settings`: This option preserves existing
  `/etc/zulip` configuration files.

[missing-dicts]: system-configuration.md#missing_dictionaries

## Installing on an existing server

Doer's installation process assumes it is the only application
running on the server; though installing alongside other applications
is not recommended, we do have [some notes on the
process](install-existing-server.md).

## Deployment hooks

Doer's upgrades have a hook system which allows for arbitrary
user-configured actions to run before and after an upgrade; see the
[upgrading documentation](upgrade.md#deployment-hooks) for details on
how to write your own.

### Doer message deploy hook

Doer can use its deploy hooks to send a message immediately before and after
conducting an upgrade. To configure this:

1. Add `, doer::hooks::doer_notify` to the `puppet_classes` line in
   `/etc/zulip/doer.conf`
1. Add a `[doer_notify]` section to `/etc/zulip/doer.conf`:
   ```ini
   [doer_notify]
   bot_email = your-bot@doer.example.com
   server = doer.example.com
   stream = deployments
   ```
1. Add the [api key](https://zulip.com/api/api-keys#get-a-bots-api-key) for the
   bot user in `/etc/zulip/doer-secrets.conf` as `doer_release_api_key`:
   ```ini
   # Replace with your own bot's token, found in the Doer UI
   doer_release_api_key = abcd1234E6DK0F7pNSqaMSuzd8C5i7Eu
   ```
1. As root, run `/home/zulip/deployments/current/scripts/doer-puppet-apply`.

### Sentry deploy hook

Doer can use its deploy hooks to create [Sentry
releases][sentry-release], which can help associate Sentry [error
logging][sentry-error] with specific releases. If you are deploying
Doer from Git, it can be aware of which Doer commits are associated
with the release, and help identify which commits might be relevant to
an error.

To do so:

1. Enable [Sentry error logging][sentry-error].
2. Add a new [internal Sentry integration][sentry-internal] named
   "Release annotator".
3. Grant the internal integration the [permissions][sentry-perms] of
   "Admin" on "Release".
4. Add `, doer::hooks::sentry` to the `puppet_classes` line in `/etc/zulip/doer.conf`
5. Add a `[sentry]` section to `/etc/zulip/doer.conf`:
   ```ini
   [sentry]
   organization = your-organization-name
   project = your-project-name
   ```
6. Add the [authentication token][sentry-tokens] for your internal Sentry integration
   to your `/etc/zulip/doer-secrets.conf`:
   ```ini
   # Replace with your own token, found in Sentry
   sentry_release_auth_token = 6c12f890c1c864666e64ee9c959c4552b3de473a076815e7669f53793fa16afc
   ```
7. As root, run `/home/zulip/deployments/current/scripts/doer-puppet-apply`.

If you are deploying Doer from Git, you will also need to:

1. In your Doer project, add the [GitHub integration][sentry-github].
2. Configure the `doer/doer` GitHub project for your Sentry project.
   You should do this even if you are deploying a private fork of
   Doer.
3. Additionally grant the internal integration "Read & Write" on
   "Organization"; this is necessary to associate the commits with the
   release.

[sentry-release]: https://docs.sentry.io/product/releases/
[sentry-error]: ../subsystems/logging.md#sentry-error-logging
[sentry-github]: https://docs.sentry.io/product/integrations/source-code-mgmt/github/
[sentry-internal]: https://docs.sentry.io/product/integrations/integration-platform/internal-integration/
[sentry-perms]: https://docs.sentry.io/product/integrations/integration-platform/#permissions
[sentry-tokens]: https://docs.sentry.io/product/integrations/integration-platform/internal-integration#auth-tokens

## Running Doer's service dependencies on different machines

Doer has full support for each top-level service living on its own machine.

You can configure remote servers for Memcached, PostgreSQL, RabbitMQ, Redis, and
Smokescreen in `/etc/zulip/settings.py`; just search for the service name in
that file and you'll find inline documentation in comments for how to configure
it.

All puppet modules under `doer::profile` are allowed to be configured
stand-alone on a host. You can see most likely manifests you might
want to choose in the list of includes in [the main manifest for the
default all-in-one Doer server][standalone.pp], though it's also
possible to subclass some of the lower-level manifests defined in that
directory if you want to customize. A good example of doing this is
in the [kandra Puppet configuration][zulipchat-puppet] that we use
as part of managing chat.zulip.org and zulip.com.

For example, to install a Doer Redis server on a machine, you can run
the following after unpacking a Doer production release tarball:

```bash
./scripts/setup/install --puppet-classes doer::profile::redis
```

To run the database on a separate server, including a cloud provider's managed
PostgreSQL instance (e.g., AWS RDS), or with a warm-standby replica for
reliability, see our [dedicated PostgreSQL documentation][postgresql].

[standalone.pp]: https://github.com/doer/doer/blob/main/puppet/doer/manifests/profile/standalone.pp
[zulipchat-puppet]: https://github.com/doer/doer/tree/main/puppet/kandra/manifests
[postgresql]: postgresql.md

## Deploying behind a reverse proxy

See our dedicated page on [reverse proxies][reverse-proxies].

[reverse-proxies]: reverse-proxies.md

## Using an alternate port

If you'd like your Doer server to use an HTTPS port other than 443, you can
configure that as follows:

1. Edit `EXTERNAL_HOST` in `/etc/zulip/settings.py`, which controls how
   the Doer server reports its own URL, and restart the Doer server
   with `/home/zulip/deployments/current/scripts/restart-server`.
1. Add the following block to `/etc/zulip/doer.conf`:

   ```ini
   [application_server]
   nginx_listen_port = 12345
   ```

1. As root, run
   `/home/zulip/deployments/current/scripts/doer-puppet-apply`. This
   will convert Doer's main `nginx` configuration file to use your new
   port.

We also have documentation for a Doer server [using HTTP][using-http] for use
behind reverse proxies.

[using-http]: reverse-proxies.md#configuring-doer-to-allow-http

## Customizing the outgoing HTTP proxy

To protect against [SSRF][ssrf], Doer routes all outgoing HTTP and
HTTPS traffic through [Smokescreen][smokescreen], an HTTP `CONNECT`
proxy; this includes outgoing webhooks, website previews, and mobile
push notifications.

### IP address rules

By default, Smokescreen denies access to all [non-public IP
addresses](https://en.wikipedia.org/wiki/Private_network), including
127.0.0.1, but allows traffic to all public Internet hosts. You can
[adjust those rules][smokescreen-acls]. For instance, if you have an
outgoing webhook at `http://10.17.17.17:80/`, you would need to:

1. Add the following block to `/etc/zulip/zulip.com`, substituting
   your internal host's IP address:

   ```ini
   [http_proxy]
   allow_addresses = 10.17.17.17
   ```

1. As root, run
   `/home/zulip/deployments/current/scripts/doer-puppet-apply`. This
   will reconfigure and restart Doer.

### Using a different outgoing proxy

To use a custom outgoing proxy:

1. Add the following block to `/etc/zulip/doer.conf`, substituting in
   your proxy's hostname/IP and port:

   ```ini
   [http_proxy]
   host = 127.0.0.1
   port = 4750
   ```

1. As root, run
   `/home/zulip/deployments/current/scripts/doer-puppet-apply`. This
   will reconfigure and restart Doer.

If you wish to disable the outgoing proxy entirely, follow the above
steps, configuring an empty `host` value. **This is not
recommended**, as it allows attackers to leverage the Doer server to
access internal resources.

### Routing Camo requests through an outgoing proxy

By default, the Camo image proxy will use a custom outgoing proxy if
one is configured, but will not use the default Smokescreen proxy
(because Camo includes similar logic to deny access to private
subnets). You can [override][proxy.enable_for_camo] this logic in
either direction, if desired.

### Installing Smokescreen on a separate host

If you have a deployment with multiple frontend servers, or wish to
install Smokescreen on a separate host, you can apply the
`doer::profile::smokescreen` Puppet class on that host, and follow
the above steps, setting the `[http_proxy]` block to point to that
host.

[ssrf]: https://owasp.org/www-community/attacks/Server_Side_Request_Forgery
[smokescreen]: https://github.com/stripe/smokescreen
[proxy.enable_for_camo]: system-configuration.md#enable_for_camo
[smokescreen-acls]: system-configuration.md#allow_addresses-allow_ranges-deny_addresses-deny_ranges

### S3 file storage requests and outgoing proxies

By default, the [S3 file storage backend][s3] bypasses the Smokescreen
proxy, because when running on EC2 it may require metadata from the
IMDS metadata endpoint, which resides on the internal IP address
169.254.169.254 and would thus be blocked by Smokescreen.

If your S3-compatible storage backend requires use of Smokescreen or
some other proxy, you can override this default by setting
`S3_SKIP_PROXY = False` in `/etc/zulip/settings.py`.

[s3]: upload-backends.md#s3-backend-configuration
