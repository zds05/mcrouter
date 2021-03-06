#!/usr/bin/env bash

source common.sh

if [[ ! -d "$PKG_DIR/fbthrift" ]]; then
  git clone https://github.com/facebook/fbthrift
  cd "$PKG_DIR/fbthrift" || die "cd fail"
  if [[ -f "$REPO_BASE_DIR/mcrouter/FBTHRIFT_COMMIT" ]]; then
    FBTHRIFT_COMMIT="$(head -n 1 "$REPO_BASE_DIR/mcrouter/FBTHRIFT_COMMIT")"
    echo "FBTHRIFT_COMMIT file found: using fbthrift commit $FBTHRIFT_COMMIT"
    git checkout "$FBTHRIFT_COMMIT"
  else
    echo "No FBTHRIFT_COMMIT file, using fbthrift HEAD=$(git rev-parse HEAD)"
  fi
fi

if [ ! -d "$PKG_DIR/mstch" ]; then
  cd "$PKG_DIR" || die "cd fail"
  git clone https://github.com/no1msd/mstch

  cd "$PKG_DIR/mstch" || die "cd fail"

  cmake -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DBUILD_SHARED_LIBS=ON \
  -DCMAKE_CXX_FLAGS="-fPIC" .
  make $MAKE_ARGS && make install $MAKE_ARGS
fi

if [ ! -d "$PKG_DIR/zstd" ]; then
  cd "$PKG_DIR" || die "cd fail"
  git clone https://github.com/facebook/zstd

  cd "$PKG_DIR/zstd" || die "cd fail"

  cmake -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" build/cmake/
  make $MAKE_ARGS && make install $MAKE_ARGS
fi

cd "$PKG_DIR/fbthrift/thrift" || die "cd fbthrift failed"

CXXFLAGS="$CXXFLAGS -fPIC" \
cmake .. -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR"
make $MAKE_ARGS && make install $MAKE_ARGS
