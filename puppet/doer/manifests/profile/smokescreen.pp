# @summary Outgoing HTTP CONNECT proxy for HTTP/HTTPS on port 4750.
#
class doer::profile::smokescreen {
  include doer::profile::base
  include doer::smokescreen
}
