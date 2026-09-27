#!/bin/bash
# Build OpenVDB (tamasmeszaros fork @a68fd58, "8.2 patched") static for i386/10.6.
# Needs Boost (deps-prefix) + TBB/OpenEXR2/Blosc (MacPorts: run 01-deps first).
. "$(dirname "$0")/common.sh"
COMMIT=a68fd58d0e2b85f01adeb8b13d7555183ab10aa5
URL="https://github.com/tamasmeszaros/openvdb/archive/${COMMIT}.zip"
SRCDIR="$DEPS_BUILD/openvdb-${COMMIT}"
mkdir -p "$DEPS_BUILD" "$DEPS_PREFIX"
if [ ! -d "$SRCDIR" ]; then
  cd "$DEPS_BUILD"
  [ -f "openvdb-${COMMIT}.zip" ] || curl -fL -o "openvdb-${COMMIT}.zip" "$URL"
  unzip -q "openvdb-${COMMIT}.zip"
  ( cd "$SRCDIR" && git apply --ignore-space-change --whitespace=fix \
      "$ROOT/0001-clang19.patch" ) || echo "WARN: OpenVDB patch apply"
fi
cmake -S "$SRCDIR" -B "$DEPS_BUILD/openvdb-build" \
  -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$DEPS_PREFIX" \
  -DCMAKE_PREFIX_PATH="$DEPS_PREFIX;$MP" \
  -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
  -DOPENVDB_BUILD_PYTHON_MODULE=OFF \
  -DUSE_BLOSC=ON \
  -DOPENVDB_CORE_SHARED=OFF -DOPENVDB_CORE_STATIC=ON \
  -DOPENVDB_ENABLE_RPATH=OFF \
  -DTBB_STATIC=OFF \
  -DOPENVDB_BUILD_VDB_PRINT=OFF \
  -DDISABLE_DEPENDENCY_VERSION_CHECKS=ON \
  -DBOOST_ROOT="$DEPS_PREFIX"
set +e
cmake --build "$DEPS_BUILD/openvdb-build" -j2 && cmake --install "$DEPS_BUILD/openvdb-build"
rc=$?; set -e
echo "OPENVDB-DONE rc=$rc"
[ $rc -eq 0 ] && ls "$DEPS_PREFIX"/lib/libopenvdb* 2>/dev/null
