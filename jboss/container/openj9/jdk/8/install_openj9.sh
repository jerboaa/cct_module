#/bin/bash
set -e
if [ $# -ne 2 ]; then
  echo "usage: $0 <tarball> <install-loc>"
  exit 1
fi
TARBALL="$1"
TARGET_DIR="$2"
TARGET_PARENT="$(dirname $TARGET_DIR)"

TMP_DIR="openj9-install"
mkdir $TMP_DIR
pushd $TMP_DIR
tar -xf "$TARBALL"
SOURCE="$(ls)"
mkdir -p "$TARGET_PARENT"
mv "$SOURCE" "$TARGET_DIR"
popd
rm -rf "$TMP_DIR" "$TARBALL"

# Set alternatives (mimics what OpenJDK RPMs do)
JAVA_BIN_DIR="$TARGET_DIR/bin"
BIN_DIR="/usr/bin"
JVM_DIR="/usr/lib/jvm"
PRIORITY=100000
NAME="$(basename $TARGET_DIR)"
ARCH="$(uname -m)"
ORIGIN="openj9"
JAVA_VER="1.8.0"
if [ ! -e "$JVM_DIR" ]; then
  mkdir -p "$JVM_DIR"
fi
# java alternative
alternatives \
  --install "$BIN_DIR/java" java $JAVA_BIN_DIR/java $PRIORITY  --family "$NAME.$ARCH" \
  --slave "$JVM_DIR/jre" jre "$TARGET_DIR" \
  --slave "$BIN_DIR/jjs" jjs "$JAVA_BIN_DIR/jjs" \
  --slave "$BIN_DIR/keytool" keytool "$JAVA_BIN_DIR/keytool" \
  --slave "$BIN_DIR/orbd" orbd "$JAVA_BIN_DIR/orbd" \
  --slave "$BIN_DIR/pack200" pack200 "$JAVA_BIN_DIR/pack200" \
  --slave "$BIN_DIR/rmid" rmid "$JAVA_BIN_DIR/rmid" \
  --slave "$BIN_DIR/rmiregistry" rmiregistry "$JAVA_BIN_DIR/rmiregistry" \
  --slave "$BIN_DIR/servertool" servertool "$JAVA_BIN_DIR/servertool" \
  --slave "$BIN_DIR/tnameserv" tnameserv "$JAVA_BIN_DIR/tnameserv" \
  --slave "$BIN_DIR/policytool" policytool "$JAVA_BIN_DIR/policytool" \
  --slave "$BIN_DIR/unpack200" unpack200 "$JAVA_BIN_DIR/unpack200"

for X in $ORIGIN $JAVA_VER ; do
  alternatives --install "$JVM_DIR/jre-$X" "jre_$X" "$TARGET_DIR" $PRIORITY --family "$NAME.$ARCH"
done

update-alternatives --install "$JVM_DIR/jre-${JAVA_VER}-${ORIGIN}" "jre_${JAVA_VER}_${ORIGIN}" "$TARGET_DIR" $PRIORITY  --family "$NAME.$ARCH"

# javac alternative
alternatives \
  --install "$BIN_DIR/javac" javac "$JAVA_BIN_DIR/javac" $PRIORITY  --family "$NAME.$ARCH" \
  --slave "$JVM_DIR/java" java_sdk "$TARGET_DIR" \
  --slave "$BIN_DIR/appletviewer" appletviewer "$JAVA_BIN_DIR/appletviewer" \
  --slave "$BIN_DIR/extcheck" extcheck "$JAVA_BIN_DIR/extcheck" \
  --slave "$BIN_DIR/idlj" idlj "$JAVA_BIN_DIR/idlj" \
  --slave "$BIN_DIR/jar" jar "$JAVA_BIN_DIR/jar" \
  --slave "$BIN_DIR/jarsigner" jarsigner "$JAVA_BIN_DIR/jarsigner" \
  --slave "$BIN_DIR/javadoc" javadoc "$JAVA_BIN_DIR/javadoc" \
  --slave "$BIN_DIR/javah" javah "$JAVA_BIN_DIR/javah" \
  --slave "$BIN_DIR/javap" javap "$JAVA_BIN_DIR/javap" \
  --slave "$BIN_DIR/jconsole" jconsole "$JAVA_BIN_DIR/jconsole" \
  --slave "$BIN_DIR/jdb" jdb "$JAVA_BIN_DIR/jdb" \
  --slave "$BIN_DIR/jdeps" jdeps "$JAVA_BIN_DIR/jdeps" \
  --slave "$BIN_DIR/jmap" jmap "$JAVA_BIN_DIR/jmap" \
  --slave "$BIN_DIR/jps" jps "$JAVA_BIN_DIR/jps" \
  --slave "$BIN_DIR/jrunscript" jrunscript "$JAVA_BIN_DIR/jrunscript" \
  --slave "$BIN_DIR/jsadebugd" jsadebugd "$JAVA_BIN_DIR/jsadebugd" \
  --slave "$BIN_DIR/jstack" jstack "$JAVA_BIN_DIR/jstack" \
  --slave "$BIN_DIR/native2ascii" native2ascii "$JAVA_BIN_DIR/native2ascii" \
  --slave "$BIN_DIR/rmic" rmic "$JAVA_BIN_DIR/rmic" \
  --slave "$BIN_DIR/schemagen" schemagen "$JAVA_BIN_DIR/schemagen" \
  --slave "$BIN_DIR/serialver" serialver "$JAVA_BIN_DIR/serialver" \
  --slave "$BIN_DIR/wsgen" wsgen "$JAVA_BIN_DIR/wsgen" \
  --slave "$BIN_DIR/wsimport" wsimport "$JAVA_BIN_DIR/wsimport" \
  --slave "$BIN_DIR/xjc" xjc "$JAVA_BIN_DIR/xjc" \
  --slave "$BIN_DIR/jdmpview" jdmpview "$JAVA_BIN_DIR/jdmpview" \
  --slave "$BIN_DIR/traceformat" traceformat "$JAVA_BIN_DIR/traceformat"

for X in $ORIGIN $JAVA_VER ; do
  alternatives \
    --install "$JVM_DIR/java-$X" "java_sdk_$X" "$TARGET_DIR" $PRIORITY  --family "$NAME.$ARCH"
done

update-alternatives --install "$JVM_DIR/java-${JAVA_VER}-${ORIGIN}" "java_sdk_${JAVA_VER}_${ORIGIN}" "$TARGET_DIR" $PRIORITY  --family "$NAME.$ARCH"
