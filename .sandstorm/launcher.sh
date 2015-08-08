#!/bin/bash
set -exuo pipefail

# OpenGrok needs libjli.so.  Our environment breaks java's link to that
# library somehow.  Hacky workaround below.
# FMI http://unix.stackexchange.com/questions/16656/problem-to-launch-java-at-debian-error-while-loading-shared-libraries-libjli
export LD_LIBRARY_PATH=/usr/lib/jvm/java-7-openjdk-amd64/jre/lib/amd64/jli/

# Create a Tomcat server for this user / grain
cd /var
if [ ! -d tomgrok ]
then
  tomcat7-instance-create -p 8000 tomgrok 
    # Sandstorm expects service on port 8000;
	# Tomcat defaults to 8080
fi

# Install a root Tomcat webapp (e.g. to redirect to
# OpenGrok's /source homepage). NB: Tomcat doesn't
# follow file symlinks by default.
if [ ! -e /var/tomgrok/webapps/ROOT ] ; then
  ln -s /opt/app/.sandstorm/tomgrok/ROOT \
    /var/tomgrok/webapps/ROOT
fi

# Start tomcat
/var/tomgrok/bin/startup.sh

# For env configuration, see:
#  https://github.com/OpenGrok/OpenGrok/blob/master/OpenGrok
export OPENGROK_VERBOSE=1
export OPENGROK_PROGRESS=1
export OPENGROK_APP_SERVER="Tomcat"
export OPENGROK_TOMCAT_BASE=/var/tomgrok/

# Init OpenGrok r/w dirs
mkdir -p /var/opengrok/data
mkdir -p /var/opengrok/etc
mkdir -p /var/opengrok/src

# Demo: let's link in some codes
ln -s /opt/app/opengrok/demo_codes /var/opengrok/src/demo_codes

## OpenGrok needs libjli.so.  Our environment breaks java's link to that
## library somehow.  Hacky workaround below.
## FMI http://unix.stackexchange.com/questions/16656/problem-to-launch-java-at-debian-error-while-loading-shared-libraries-libjli
#export LD_LIBRARY_PATH=/usr/lib/jvm/java-7-openjdk-amd64/jre/lib/amd64/jli/

# Tell OpenGrok to initialize (search) indices
cd /var/opengrok
/opt/app/opengrok/bin/OpenGrok deploy 

# Tell OpenGrok to run a preliminary index
/opt/app/opengrok/bin/OpenGrok index

# NB: All the calls above are non-blocking, so to keep
# the grain running we could sleep or (debug) tail logs
tail -F /var/tomgrok/logs/*

