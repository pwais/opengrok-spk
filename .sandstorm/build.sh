#!/bin/bash
set -exuo pipefail

# This script is run in the VM each time you run `vagrant-spk dev`.  This is
# the ideal place to invoke anything which is normally part of your app's build
# process - transforming the code in your repository into the collection of files
# which can actually run the service in production
#
# Some examples:
#
#   * For a C/C++ application, calling
#       ./configure && make && make install
#   * For a Python application, creating a virtualenv and installing
#     app-specific package dependencies:
#       virtualenv /opt/app/env
#       /opt/app/env/bin/pip install -r /opt/app/requirements.txt
#   * Building static assets from .less or .sass, or bundle and minify JS
#   * Collecting various build artifacts or assets into a deployment-ready
#     directory structure

# By default, this script does nothing.  You'll have to modify it as
# appropriate for your application.


## For env configuration, see:
##  https://github.com/OpenGrok/OpenGrok/blob/master/OpenGrok
#export OPENGROK_INSTANCE_BASE=/opt/app

## Set up dangling symlinks to make OpenGrok r/w to /var
## (we will realize the symlink sources in launch.sh)
#ln -sf /var/opengrok/data $OPENGROK_INSTANCE_BASE/data
#ln -sf /var/opengrok/etc  $OPENGROK_INSTANCE_BASE/etc
#ln -sf /var/opengrok/src  $OPENGROK_INSTANCE_BASE/src

# Stage an OpenGrok install
cd /opt/app
if [ ! -d opengrok ]
then
  echo "Fetching a pre-build tarball of OpenGrok"
  wget -O - https://java.net/projects/opengrok/downloads/download/opengrok-0.12.1.tar.gz | tar zxvf -
  mv opengrok-* opengrok
fi
exit 0



