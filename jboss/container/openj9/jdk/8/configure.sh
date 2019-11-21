#!/bin/sh
# Configure module
set -e

SCRIPT_DIR=$(dirname $0)
ARTIFACTS_DIR=${SCRIPT_DIR}/artifacts

chown -R jboss:root $SCRIPT_DIR
chmod -R ug+rwX $SCRIPT_DIR
$SCRIPT_DIR/install_openj9.sh /tmp/artifacts/openj9-binary-$(uname -m).tar.gz "/opt/jboss/container/java-1.8.0-openj9"

# Set this JDK as the alternative in use
_arch="$(uname -i)"
alternatives --set java java-1.8.0-openj9.${_arch}
alternatives --set javac java-1.8.0-openj9.${_arch}
alternatives --set java_sdk_openj9 java-1.8.0-openj9.${_arch}
alternatives --set jre_openj9 java-1.8.0-openj9.${_arch}

# Update securerandom.source for quicker starts (must be done after removing jdk 8, or it will hit the wrong files)
JAVA_SECURITY_FILE=/usr/lib/jvm/java/jre/lib/security/java.security
SECURERANDOM=securerandom.source
if grep -q "^$SECURERANDOM=.*" $JAVA_SECURITY_FILE; then
    sed -i "s|^$SECURERANDOM=.*|$SECURERANDOM=file:/dev/urandom|" $JAVA_SECURITY_FILE
else
    echo $SECURERANDOM=file:/dev/urandom >> $JAVA_SECURITY_FILE
fi
