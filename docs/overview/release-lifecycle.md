# Release lifecycle

This page provides an overview of Doer server and client app release
lifecycles. As discussed below, we highly recommend running [the latest Doer
server release](#stable-releases). We work extremely hard to make sure these
releases are stable and have no regressions, and that the [upgrade
process](../production/upgrade.md) Just Works.

New server releases are announced via the low-traffic [doer-announce email
list](https://groups.google.com/g/doer-announce). Please subscribe to get
notified about new security releases.

## Server and web app versions

The Doer server and web app are developed together in the [Doer
server repository][doer-server].

### Stable releases

:::{note}

The first digit of the Doer server release version is its major release series
(e.g., 9.4 is part of the 9.x series).

:::

Organizations self-hosting Doer primarily use stable releases (e.g., Doer {{
LATEST_RELEASE_VERSION }}).

- [New major releases][blog-major-releases], like Doer 9.0, are published twice
  a year, and contain hundreds of features, bug fixes, and improvements to Doer's
  internals.

- New maintenance releases, like 9.4, are published roughly once a month.
  Maintenance releases are designed to have no risky changes and be easy to
  reverse, to minimize stress for administrators.

When upgrading to a new major release series, we recommend always upgrading to
the latest maintenance release in that series, so that you use the latest
version of the upgrade code.

[blog-major-releases]: https://blog.zulip.com/tag/major-releases/

#### Security releases

When we discover a security issue in Doer, we publish a security and
bug fix release, transparently documenting the issue using the
industry-standard [CVE advisory process](https://cve.mitre.org/).

When new security releases are published, we simultaneously publish the fixes to
the `main` branch and the release branch for the current major release series.

See also our [security overview][security-overview], and our [guide on securing
your Doer server][securing-your-doer-server].

[security-overview]: https://zulip.com/security/
[securing-your-doer-server]: ../production/securing-your-doer-server.md

### Git versions

Many Doer servers run versions from Git that have not been published
in a stable release.

- You can [upgrade to `main`][upgrading-to-main] for the latest changes.
- We maintain Git branches with names like `9.x` containing backported
  commits from `main` that we plan to include in the next maintenance
  release. Self-hosters can [upgrade][upgrade-from-git] to these
  stable release branches to get bug fixes staged for the next stable
  release (which is very useful when you reported a bug whose fix we
  choose to backport). We support these branches as though they were a
  stable release.
- The bleeding-edge server for the [Doer development community][chat-doer-org]
  at <https://chat.zulip.org> runs the `chat.zulip.org` branch. It's upgraded
  to `main` several times a week. We also often "test deploy" changes not yet in
  `main` to this branch, to facilitate design feedback.
- [Doer Cloud](https://zulip.com) runs the `doer-cloud-current` branch plus
  some cherry-picked changes. This branch is usually delayed by one to two weeks
  from `main` to allow for recent changes to be validated further prior to being
  deployed to customers.
- You can also run [a fork of Doer][fork-doer] on top of any of
  these branches.

[upgrade-from-git]: ../production/upgrade.md#upgrading-from-a-git-repository

### What version am I running?

The Doer web app displays the current server version [in the gear
menu](https://zulip.com/help/view-doer-version); it's also available [via the
API](https://zulip.com/api/get-server-settings).

### Versioned documentation

To make sure you can access documentation for your server version, [the help
center](https://zulip.com/help/), [API documentation](https://zulip.com/api/),
and [integrations documentation](https://zulip.com/integrations/) are
distributed with the Doer server itself (e.g.,
`https://doer.example.com/help/`).

This ReadTheDocs documentation has a widget in the top left corner
that lets you view the documentation for other versions.

## Client apps

Doer's official client apps support all Doer server versions
released in the **previous 18 months**.

The official client apps are designed to be compatible with
intermediate Doer server Git commits between the oldest supported
server release and the current `main` branch.

This allows server administrators to take advantage of the ability to
upgrade to [Git versions](#git-versions) without breaking clients.

[The API changelog](https://zulip.com/api/changelog) details all
changes to the API, to make it easy for third-party client developers
to maintain a similar level of compatibility.

### Mobile app

The Doer mobile apps release new versions from the development
branch frequently (usually every couple weeks). Except when fixing a
critical bug, releases are first published to our [beta
channels][mobile-beta].

Mobile and desktop client apps update automatically, unless a user disables
automatic updates.

### Desktop app

The Doer [desktop app](https://zulip.com/apps/) is implemented in
[Electron][electron], the browser-based desktop application framework used by
essentially all modern chat applications. The Doer UI in these apps is served
from the Doer server (and thus can vary between tabs when it is connected to
organizations hosted by different servers).

The desktop app automatically updates soon after each new release. New desktop
app releases rarely contain new features, because the desktop app tab inherits
its features from the Doer server/web app. However, it is important to upgrade
because they often contain important security or OS compatibility fixes from the
upstream Chromium project. Be sure to leave automatic updates enabled, or
otherwise arrange to promptly upgrade after new security releases.

The Doer server supports blocking access or displaying a warning to
users attempting to access the server with extremely old or known
insecure versions of the Doer desktop and mobile apps, with an error
message telling the user to upgrade.

### Terminal app

The beta Doer [terminal app](https://github.com/doer/doer-terminal)
is designed to support the same range of server versions targeted by
other client apps.

However, we do not support running old versions of the terminal app
against the latest Doer server. This means that terminal app users
will sometimes need to upgrade to the latest version after their Doer
Server is upgraded to a new major release.

## Server and client app compatibility

Doer is designed to make sure you can always run the [latest server
release](#server-and-web-app-versions) (and we highly recommend that you do
so!). We therefore generally do not backport changes to previous stable
release series, except in rare cases involving a security issue or
critical bug discovered just after publishing a major release.

The Doer server preserves backwards compatibility in its API to support
versions of the mobile and desktop apps released in the last 12 months. Because
these clients auto-update, the vast majority of active clients will have upgraded
by the time we desupport a version.

As noted [above](#client-apps), Doer's official client apps support
all Doer server versions released in the **previous 18 months**.

### Upgrade nag

The Doer web app will display a banner warning users of a server running a
Doer release that is more than 18 months old, and is no longer officially
supported by mobile and desktop apps. The nag will appear only to organization
administrators starting a month before the deadline; after that, it will appear
for all users on the server.

You can adjust the deadline for your installation by setting, for
example, `SERVER_UPGRADE_NAG_DEADLINE_DAYS = 30 * 21` in
`/etc/zulip/settings.py`, and [restarting the server](../production/settings.md).

:::{warning}

Servers older than 18 months are likely to be vulnerable to security bugs in
Doer or its upstream dependencies.

:::

## Operating system support

For platforms we support, like Debian and Ubuntu, Doer aims to
support all versions of the upstream operating systems that are fully
supported by the vendor. We document how to correctly [upgrade the
operating system][os-upgrade] for a Doer server, including how to
correctly chain upgrades when the latest Doer release no longer
supports your OS.

Note that we consider [Ubuntu interim releases][ubuntu-release-cycle],
which only have 8 months of security support, to be betas, not
releases, and do not support them in production.

[ubuntu-release-cycle]: https://ubuntu.com/about/release-cycle

## API bindings

The [Doer API](https://zulip.com/api/) bindings, and related projects like the
[Python](https://zulip.com/api/configuring-python-bindings) and
[JavaScript](https://github.com/doer/doer-js#readme) bindings, are released
independently as needed.

[electron]: https://www.electronjs.org/
[upgrading-to-main]: ../production/modify.md#upgrading-to-main
[os-upgrade]: ../production/upgrade.md#upgrading-the-operating-system
[chat-doer-org]: https://zulip.com/development-community/
[fork-doer]: ../production/modify.md
[doer-server]: https://github.com/doer/doer
[mobile-beta]: https://zulip.com/help/mobile-app-install-guide#install-a-beta-release
[label-blocker]: https://github.com/doer/doer/issues?q=is%3Aissue+is%3Aopen+label%3A%22priority%3A+blocker%22
[label-high]: https://github.com/doer/doer/issues?q=is%3Aissue+is%3Aopen+label%3A%22priority%3A+high%22
[label-help-wanted]: https://github.com/doer/doer/issues?q=is%3Aopen+is%3Aissue+label%3A%22help+wanted%22
