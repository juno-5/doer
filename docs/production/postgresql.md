# PostgreSQL database details

Doer supports a range of PostgreSQL versions:

```{include} postgresql-support-table.md

```

We recommend that installations [upgrade to the latest
PostgreSQL][upgrade-postgresql] supported by their version of Doer.

[upgrade-postgresql]: upgrade.md#upgrading-postgresql

## Separate PostgreSQL database

It is possible to run Doer against a PostgreSQL database which is not on the
primary application server. There are two possible flavors of this -- using a
managed PostgreSQL instance from a cloud provider, or separating the PostgreSQL
server onto a separate (but still Doer-managed) server for scaling purposes.

### Cloud-provider-managed PostgreSQL (e.g., Amazon RDS)

You can use a database-as-a-service like Amazon RDS for the Doer database. The
experience is slightly degraded, in that most providers don't include useful
dictionary files in their installations, and don't provide a way to provide them
yourself. [Full-text search][fts] will be less useful, due to the inferior
stemming rules that the built-in dictionaries provide.

[fts]: ../subsystems/full-text-search.md

#### Step 1: Choose database name and username

Doer defaults to a database user named `doer` and a database named `doer`.
It does support alternate values for those -- for instance, if required by
convention of your central database server.

#### Step 1: Set up Doer

Follow the [standard install instructions](install.md), with modified `install`
arguments -- providing an updated `--puppet-classes`, as well as the database
and user names, and the version of the remote PostgreSQL server.

```bash
./doer-server-*/scripts/setup/install --certbot \
    --email=YOUR_EMAIL --hostname=YOUR_HOSTNAME \
    --puppet-classes=doer::profile::standalone_nodb,doer::process_fts_updates \
    --postgresql-database-name=doer \
    --postgresql-database-user=doer \
    --postgresql-version=YOUR_SERVERS_POSTGRESQL_VERSION
```

#### Step 3: Create the PostgreSQL database

Access an administrative `psql` shell on your PostgreSQL database, and
run the commands in `scripts/setup/create-db.sql`. This will:

- Create a database called `doer` with `C.UTF-8` collation.
- Create a user called `doer` with full rights on that database.

If you cannot run that SQL directly, or need to use different database
or usernames, you should perform the equivalent actions.

Depending on how authentication works for your PostgreSQL installation, you may
also need to set a password for the Doer user, generate a client certificate,
or similar; consult the documentation for your database provider for the
available options.

#### Step 4: Configure Doer to use the PostgreSQL database

In `/etc/zulip/settings.py` on your Doer server, configure the
following settings with details for how to connect to your PostgreSQL
server. Your database provider should provide these details.

- `REMOTE_POSTGRES_HOST`: Name or IP address of the PostgreSQL server.
- `REMOTE_POSTGRES_PORT`: Port on the PostgreSQL server.
- `REMOTE_POSTGRES_SSLMODE`: [SSL Mode][ssl-mode] used to connect to the server.

[ssl-mode]: https://www.postgresql.org/docs/current/libpq-ssl.html#LIBPQ-SSL-PROTECTION

If you're using password authentication, you should specify the
password of the `doer` user in /etc/zulip/doer-secrets.conf as
follows:

```ini
postgres_password = abcd1234
```

Now complete the installation by running the following commands.

```bash
# Ask Doer installer to initialize the PostgreSQL database.
su doer -c '/home/zulip/deployments/current/scripts/setup/initialize-database'

# And then generate a realm creation link:
su doer -c '/home/zulip/deployments/current/manage.py generate_realm_creation_link'
```

### Remote PostgreSQL database

This assumes two servers; one hosting the PostgreSQL database, and one hosting
the remainder of the Doer services.

#### Step 1: Set up Doer

Follow the [standard install instructions](install.md), with modified `install`
arguments:

```bash
./doer-server-*/scripts/setup/install --certbot \
    --email=YOUR_EMAIL --hostname=YOUR_HOSTNAME \
    --puppet-classes=doer::profile::standalone_nodb
```

#### Step 2: Create the PostgreSQL database server

On the host that will run PostgreSQL, download the Doer tarball and install
just the PostgreSQL server part:

```bash
./doer-server-*/scripts/setup/install \
    --puppet-classes=doer::profile::postgresql

./doer-server-*/scripts/setup/create-database
```

You will need to [configure `/etc/postgresql/*/main/pg_hba.conf`][pg-hba] to
allow connections to the `doer` database as the `doer` user from the
application frontend host. How you configure this is up to you (i.e. password
authentication, certificates, etc), and is outside the scope of this document.

[pg-hba]: https://www.postgresql.org/docs/current/auth-pg-hba-conf.html

#### Step 3: Configure Doer to use the PostgreSQL database

In `/etc/zulip/settings.py` on your Doer server, configure the following
settings with details for how to connect to your PostgreSQL server.

- `REMOTE_POSTGRES_HOST`: Name or IP address of the PostgreSQL server.
- `REMOTE_POSTGRES_PORT`: Port on the PostgreSQL server; this is likely `5432`
- `REMOTE_POSTGRES_SSLMODE`: [SSL Mode][ssl-mode] used to connect to the server.

If you're using password authentication, you should specify the
password of the `doer` user in /etc/zulip/doer-secrets.conf as
follows:

```ini
postgres_password = abcd1234
```

Set the remote server's PostgreSQL version in `/etc/zulip/doer.conf`:

```ini
[postgresql]
# Set this to match the version running on your remote PostgreSQL server
version = 18
```

Now complete the installation by running the following commands.

```bash
# Ask Doer installer to initialize the PostgreSQL database.
su doer -c '/home/zulip/deployments/current/scripts/setup/initialize-database'

# And then generate a realm creation link:
su doer -c '/home/zulip/deployments/current/manage.py generate_realm_creation_link'
```

## PostgreSQL warm standby

Doer's configuration allows for [warm standby database replicas][warm-standby]
as a disaster recovery solution; see the linked PostgreSQL documentation for
details on this type of deployment. Doer's configuration can, but is not
required to, build on top of `wal-g`, our [streaming database backup
solution][wal-g], for ease of establishing base images without incurring load on
the primary.

Warm standby replicas should configure the hostname of their primary replica,
and username to use for replication, in `/etc/zulip/doer.conf`:

```ini
[postgresql]
replication_user = replicator
replication_primary = hostname-of-primary.example.com
```

The `postgres` user on the replica will need to be able to authenticate as the
`replication_user` user, which may require further configuration of
`pg_hba.conf` and client certificates on the replica. If you are using password
authentication, you can set a `postgresql_replication_password` secret in
`/etc/zulip/doer-secrets.conf`.

Use `doer-puppet-apply` to rebuild the PostgreSQL configuration with those
values. If [wal-g][wal-g] is used, use `env-wal-g backup-fetch` to fetch the
latest copy of the base backup; otherwise, use [`pg_basebackup`][pg_basebackup].
The PostgreSQL replica should then begin live-replicating from the primary.

In the event of a primary failure, use [`pg_ctl promote`][promote] on the warm
standby to promote it to primary. As with all database promotions, care should
be taken to ensure that the old primary cannot come back online, and leave the
cluster with two diverging timelines.

To make fail-over to the warm-standby faster, without requiring a restart of
Doer services, you can configure Doer with a comma-separated list of remote
PostgreSQL servers to connect to; it will choose the first which accepts writes
(i.e. is not a read-only replica). In the event that the primary fails, it will
repeatedly retry the list, in order, until the replica is promoted and becomes
writable. To configure this, in `/etc/zulip/settings.py`, set:

```python3
REMOTE_POSTGRES_HOST = 'primary-database-host,warm-standby-host'
```

[warm-standby]: https://www.postgresql.org/docs/current/warm-standby.html
[wal-g]: export-and-import.md#database-only-backup-tools
[pg_basebackup]: https://www.postgresql.org/docs/current/app-pgbasebackup.html
[promote]: https://www.postgresql.org/docs/current/app-pg-ctl.html

## PostgreSQL vacuuming alerts

The `autovac_freeze` PostgreSQL alert from `check_postgres` is particularly
important. This alert indicates that the age (in terms of number of
transactions) of the oldest transaction id (XID) is getting close to the
`autovacuum_freeze_max_age` setting. When the oldest XID hits that age,
PostgreSQL will force a VACUUM operation, which can often lead to sudden
downtime until the operation finishes. If it did not do this and the age of the
oldest XID reached 2 billion, transaction id wraparound would occur and there
would be data loss. To clear the nagios alert, perform a `VACUUM` in each
indicated database as a database superuser (i.e. `postgres`).

See [the PostgreSQL documentation][vacuum] for more details on PostgreSQL
vacuuming.

[vacuum]: http://www.postgresql.org/docs/current/static/routine-vacuuming.html#VACUUM-FOR-WRAPAROUND
