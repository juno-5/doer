#!/usr/bin/env bash

set -e
set -u

if ! doer_api_key=$(crudini --get /etc/zulip/doer-secrets.conf secrets doer_release_api_key); then
    echo "doer_notify: No doer_release_api_key set!  Set doer_release_api_key in /etc/zulip/doer-secrets.conf"
    exit 0
fi

if ! doer_notify_bot_email=$(crudini --get /etc/zulip/doer.conf doer_notify bot_email); then
    echo "doer_notify: No doer_notify.bot_email set in /etc/zulip/doer.conf"
    exit 0
fi

if ! doer_notify_server=$(crudini --get /etc/zulip/doer.conf doer_notify server); then
    echo "doer_notify: No doer_notify.server set in /etc/zulip/doer.conf"
    exit 0
fi

if ! doer_notify_stream=$(crudini --get /etc/zulip/doer.conf doer_notify stream); then
    echo "doer_notify: No doer_notify.stream set in /etc/zulip/doer.conf"
    exit 0
fi

from=${DOER_OLD_MERGE_BASE_COMMIT:-$DOER_OLD_VERSION}
to=${DOER_NEW_MERGE_BASE_COMMIT:-$DOER_NEW_VERSION}
deploy_environment=$(crudini --get /etc/zulip/doer.conf machine deploy_type || echo "development")
# shellcheck disable=SC2034
commit_count=$(git rev-list "${from}..${to}" | wc -l)

doer_send() {
    uv run --no-sync doer-send \
        --site "$doer_notify_server" \
        --user "$doer_notify_bot_email" \
        --api-key "$doer_api_key" \
        --stream "$doer_notify_stream" \
        --subject "$deploy_environment deploy" \
        --message "$1"
}
