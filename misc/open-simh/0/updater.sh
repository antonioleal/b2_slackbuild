#!/bin/bash

# Slackware updater script for open-simh

# Copyright 2023-2024 Antonio Leal, Porto Salvo, Oeiras, Portugal
# All rights reserved.
#
# Redistribution and use of this script, with or without modification, is
# permitted provided that the following conditions are met:
#
# 1. Redistributions of this script must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
#  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
#  EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
#  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
#  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
#  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

PRGNAM=open-simh
set -e
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $SCRIPT_DIR

################################
# check versions               #
################################

# NEWVERSION
COMMIT=`git ls-remote https://github.com/open-simh/simh/ | head -1 | cut  -f 1`
NEWVERSION=${COMMIT:0:7}

################################
# download tarball             #
################################
TARBALL=simh-$COMMIT.tar.gz
set +e
rm simh-*.tar.gz 2> /dev/null
set -e
wget https://github.com/${PRGNAM}/simh/archive/${NEWVERSION}/${TARBALL}
if [ ! -f ./${TARBALL} ]
then
    echo "File $TARBALL not found, aborting..."
    exit
fi
mv $TARBALL ..

################################
# write templates              #
################################
MD5=`md5sum ../$TARBALL | cut -d " " -f 1`
DATEVERSION=`tar tvfz ../$TARBALL | head -n1 | awk '{ print $4 }' | awk 'BEGIN { FS = "-" } ; { print $1$2$3 }'`
sed -e "s/\${_version_}/${NEWVERSION}/" -e "s/\${_fullversion_}/${DATEVERSION}_${NEWVERSION}/" -e "s/\${_commit_}/$COMMIT/" -e "s/\${_md5_}/$MD5/" $SCRIPT_DIR/template/${PRGNAM}.info.template > ../${PRGNAM}.info
sed -e "s/\${_version_}/${NEWVERSION}/" -e "s/\${_fullversion_}/${DATEVERSION}_${NEWVERSION}/" -e "s/\${_commit_}/$COMMIT/" $SCRIPT_DIR/template/${PRGNAM}.SlackBuild.template > ../${PRGNAM}.SlackBuild
chmod -x ../${PRGNAM}.SlackBuild