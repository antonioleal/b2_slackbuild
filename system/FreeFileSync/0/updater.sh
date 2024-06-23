#!/bin/bash

# Slackware updater script for FreeFileSync

# Copyright 2023 Antonio Leal, Porto Salvo, Oeiras, Portugal
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

PRGNAM=FreeFileSync
set -e
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $SCRIPT_DIR

################################
# get versions tarball         #
################################

NEWVERSION=`curl -s https://freefilesync.org/archive.php | head -n 20 | grep "Download FreeFileSync" | cut -d " " -f 5 | rev | cut -c2- | rev`
TARBALL=FreeFileSync_${NEWVERSION}_Linux.tar.gz


################################
# download tarball             #
################################

TARBALL=${PRGNAM}_${NEWVERSION}_Linux.tar.gz
wget https://freefilesync.org/download/$TARBALL
if [ ! -f ./$TARBALL ]
then
    echo "File $TARBALL not found, aborting..."
    exit
fi

# delete old tarball and place new one
set +e
rm -i ../*.tar.gz
mv *.tar.gz ..
set -e

################################
# write templates              #
################################
MD5=`md5sum ../$TARBALL | cut -d " " -f 1`
sed -e "s/\${_version_}/$NEWVERSION/" -e "s/\${_file_}/$TARBALL/" -e "s/\${_md5_}/$MD5/" $SCRIPT_DIR/template/${PRGNAM}.info.template > ../${PRGNAM}.info
sed -e "s/\${_version_}/$NEWVERSION/" $SCRIPT_DIR/template/${PRGNAM}.SlackBuild.template > ../${PRGNAM}.SlackBuild
chmod -x ../${PRGNAM}.SlackBuild


