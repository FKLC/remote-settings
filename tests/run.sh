#!/usr/bin/env bash
set -eo pipefail

: "${SERVER:=http://web:8888/v1}"

usage() {
    echo "usage: ./run.sh start"
    echo ""
    echo "    start                         Start tests"
    echo ""
    exit 1
}

[ $# -lt 1 ] && usage

case $1 in
start)
    wget -q --tries=180 --retry-connrefused --waitretry=1 -O /dev/null $SERVER || (echo "Can't reach $SERVER" && exit 1)
    http --check-status $SERVER/__heartbeat__
    http POST $SERVER/__flush__
    pytest --driver Remote --capability browserName firefox --base-url $SERVER/admin --verify-base-url integration_test.py --server $SERVER
    ;;
*)
    exec "$@"
    ;;
esac
