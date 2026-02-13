# @summary Complete Doer server on one server
#
# This class includes all the modules you need to run an entire Doer
# installation on a single server.  If desired, you can split up the
# different `doer::profile::*` components of a Doer installation
# onto different servers:
#
#  - doer::profile::app_frontend
#  - doer::profile::memcached
#  - doer::profile::postgresql
#  - doer::profile::rabbitmq
#  - doer::profile::redis
#  - doer::profile::smokescreen
#
# See the corresponding configuration in /etc/zulip/settings.py for
# how to find the various services is also required to make this work.

class doer::profile::standalone {
  include doer::profile::standalone_nodb
  include doer::profile::postgresql
}
