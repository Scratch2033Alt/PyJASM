#!/bin/sh

# Macs come with FreeBSD coreutils which doesn't have the -s option
# so feature detect and work around it.
if which grealpath > /dev/null 2>&1; then
    # It has brew installed gnu core utils, use that
    REALPATH="grealpath -s"
elif which realpath > /dev/null 2>&1 && realpath --version > /dev/null 2>&1 && realpath --version | grep GNU > /dev/null 2>&1; then
    # realpath points to GNU realpath so use it.
    REALPATH="realpath -s"
else
    # Shim for macs without GNU coreutils
    abs_path () {
        echo "$(cd "$(dirname "$1")" || exit; pwd)/$(basename "$1")"
    }
    REALPATH=abs_path
fi

# We compute our own path, not following symlinks and pass it in so that
# node_entry.mjs can set sys.executable correctly.
# Intentionally allow word splitting on NODEFLAGS.
exec node $NODEFLAGS /home/runner/work/PyJASM/PyJASM/cpython/cross-build/wasm32-emscripten/build/python/node_entry.mjs --this-program="$($REALPATH "$0")" "$@"
