#!/usr/bin/env bash

set -e
set -x

BASEDIR=$(pwd)

DESTDIR=${HOME}/dist
BUILDDIR=${HOME}/build
VENVDIR=${HOME}/venv
PREFIX=/usr/local

# 
mkdir -p ${DESTDIR}
mkdir -p ${BUILDDIR}
mkdir -p ${VENVDIR}

# buildbox-*
export BUILDBOX_COMMON_SOURCE_ROOT=${BASEDIR}/buildbox-common
CMAKE_OPTS="-DBuildboxCommon_DIR=${DESTDIR}${PREFIX}/lib/cmake/BuildboxCommon/ -DBUILD_TESTING=OFF"

for SRC in \
    buildbox-common \
    buildbox-casd \
    buildbox-worker \
    buildbox-run-bubblewrap \
    buildbox-run-hosttools \
    buildbox-run-userchroot
do
    mkdir -p ${BUILDDIR}/${SRC} \
    && cd ${BUILDDIR}/${SRC} \
    && cmake ${CMAKE_OPTS} ${BASEDIR}/${SRC} \
    && make DESTDIR=${DESTDIR} install
done

# BuildStream
virtualenv ${VENVDIR}/buildstream
${VENVDIR}/buildstream/bin/pip3 install -r ${BASEDIR}/buildstream/requirements/dev-requirements.txt
for SRC in \
    buildstream \
    bst-plugins-experimental \
    bst-plugins-container
do
    ${VENVDIR}/buildstream/bin/pip3 install --editable ${BASEDIR}/${SRC}
done

# Simplify PATH
ln -sf ${DESTDIR}${PREFIX}/bin/* ${VENVDIR}/buildstream/bin/

