#!/bin/bash
set -exuo pipefail

# Stage an OpenGrok install
cd /opt/app
if [ ! -d opengrok ]
then
  echo "Fetching a pre-build tarball of OpenGrok"
  wget -O - https://java.net/projects/opengrok/downloads/download/opengrok-0.12.1.tar.gz | tar zxvf -
  mv opengrok-* opengrok
fi

# Demo: let's check out some codes
cd opengrok
if [ ! -d demo_codes ]
then
  mkdir -p demo_codes
  cd demo_codes
  git clone --depth 1 https://github.com/sandstorm-io/capnproto.git
fi

