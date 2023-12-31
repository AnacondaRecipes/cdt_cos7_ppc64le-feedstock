#!/bin/bash

set -e

mkdir -p ${PREFIX}/powerpc64le-conda_cos7-linux-gnu/sysroot
RPMS=$(find "${SRC_DIR}"/binary -name "*.rpm" -exec printf "." \; | wc -c | tr -d " ")
THE_RPM=$(find "${SRC_DIR}"/binary -name "*.rpm")
TOTAL=$(find "${SRC_DIR}"/binary -type f -exec printf "." \; | wc -c | tr -d " ")
pushd ${PREFIX}/powerpc64le-conda_cos7-linux-gnu/sysroot > /dev/null 2>&1
  if [[ ${RPMS} == 1 ]] && [[ ${TOTAL} == 1 ]] && [[ -f ${THE_RPM} ]]; then
    "${RECIPE_DIR}"/rpm2cpio "${THE_RPM}" | cpio -idmv
  else
    cp -Rf "${SRC_DIR}"/binary/* .
  fi
popd > /dev/null 2>&1


pushd ${PREFIX}/powerpc64le-conda_cos7-linux-gnu/sysroot > /dev/null 2>&1
  pushd ./usr/share/systemtap/tapset/powerpc > /dev/null 2>&1
    # These files end up with relative symlinks that exceed the tar maximum length of 100. Not much
    # we can do here, what should cb do when asked to package the impossible?
    rm -f *.stp
  popd
popd

pushd "${PREFIX}"
ln -s powerpc64le-conda_cos7-linux-gnu powerpc64le-conda-linux-gnu
popd


