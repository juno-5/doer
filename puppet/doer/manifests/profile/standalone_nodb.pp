# @summary Complete Doer server, except the database server.
#
# This includes all of the parts necessary to run an entire Doer
# installation on a single server, except the database.  It is assumed
# that the PostgreSQL database is either hosted on another server with
# the `doer::profile::postgresql` class applied, or a cloud-managed
# database is used (e.g. AWS RDS).
#
# @see https://zulip.readthedocs.io/en/latest/production/postgresql.html
class doer::profile::standalone_nodb {
  include doer::profile::app_frontend
  include doer::profile::memcached
  include doer::profile::rabbitmq
  include doer::profile::redis
  include doer::localhost_camo
}
