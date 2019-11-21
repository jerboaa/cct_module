#!/bin/sh
# Configure module
set -e

SCRIPT_DIR=$(dirname $0)
ARTIFACTS_DIR=${SCRIPT_DIR}/artifacts

chown -R jboss:root $SCRIPT_DIR
chmod -R ug+rwX $SCRIPT_DIR
$SCRIPT_DIR/install_openj9.sh /tmp/artifacts/openj9-binary-$(uname -m).tar.gz "/opt/jboss/container/java-1.8.0-openj9"
