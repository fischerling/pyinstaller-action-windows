#!/bin/bash

# Fail on errors.
set -e

# Make sure .bashrc is sourced
. /root/.bashrc

# Allow the workdir to be set using an env var.
# Useful for CI pipiles which use docker for their build steps
# and don't allow that much flexibility to mount volumes
WORKDIR=${1:-/src}

PYPI_URL=$2

PYPI_INDEX_URL=$3

SPEC_FILE=${4:-*.spec}

REQUIREMENTS=${5:-requirements.txt}

python -m pip install --upgrade pip wheel setuptools

#
# In case the user specified a custom URL for PYPI, then use
# that one, instead of the default one.
#
if [[ "$PYPI_URL" != "https://pypi.python.org/" ]] || \
   [[ "$PYPI_INDEX_URL" != "https://pypi.python.org/simple" ]]; then
    mkdir -p /wine/drive_c/users/root/pip
    {
        echo "[global]"
        echo "index = $PYPI_URL"
        echo "index-url = $PYPI_INDEX_URL"
        # the funky looking regexp just extracts the hostname, excluding port
        # to be used as a trusted-host.
        echo "trusted-host = $(echo "$PYPI_URL" | perl -pe 's|^.*?://(.*?)(:.*?)?/.*$|$1|')"
    } > /wine/drive_c/users/root/pip/pip.ini

    echo "Using custom pip.ini: "
    cat /wine/drive_c/users/root/pip/pip.ini
fi

cd "$WORKDIR"

if [ -f "${REQUIREMENTS}" ]; then
    pip install -r "${REQUIREMENTS}"
fi



if [[ "$*" == "" ]]; then
    bash
else
    pyinstaller --clean -y --dist ./dist/windows --workpath /tmp ${SPEC_FILE}
    chown -R --reference=. ./dist/windows
fi
