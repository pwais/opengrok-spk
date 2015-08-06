#!/bin/bash
set -exuo pipefail
# This script is run every time an instance of our app - aka grain - starts up.
# This is the entry point for your application both when a grain is first launched
# and when a grain resumes after being previously shut down.
#
# This script is responsible for launching everything your app needs to run.  The
# thing it should do *last* is:
#
#   * Start a process in the foreground listening on port 8000 for HTTP requests.
#
# This is how you indicate to the platform that your application is up and
# ready to receive requests.  Often, this will be something like nginx serving
# static files and reverse proxying for some other dynamic backend service.
#
# Other things you probably want to do in this script include:
#
#   * Building folder structures in /var.  /var is the only non-tmpfs folder
#     mounted read-write in the sandbox, and when a grain is first launched, it
#     will start out empty.  It will persist between runs of the same grain, but
#     be unique per app instance.  That is, two instances of the same app have
#     separate instances of /var.
#   * Preparing a database and running migrations.  As your package changes
#     over time and you release updates, you will need to deal with migrating
#     data from previous schema versions to new ones, since users should not have
#     to think about such things.
#   * Launching other daemons your app needs (e.g. mysqld, redis-server, etc.)

# By default, this script does nothing.  You'll have to modify it as
# appropriate for your application.


# For env configuration, see:
#  https://github.com/OpenGrok/OpenGrok/blob/master/OpenGrok
export OPENGROK_INSTANCE_BASE=/opt/app
export OPENGROK_VERBOSE=1
export OPENGROK_PROGRESS=1
export OPENGROK_APP_SERVER="Tomcat"

# Realize OpenGrok r/w dirs set up in build.sh
mkdir -p /var/opengrok/data
mkdir -p /var/opengrok/etc
mkdir -p /var/opengrok/src

# Start OpenGrok's servlet container: Tomcat
#sudo service tomcat7 start

#export OPENGROK_TOMCAT_BASE=/var/lib/tomcat7/
bash -xc "if [ -d \"/var/lib/tomcat7/webapps\" ]; then echo 'yay'; else echo 'nope'; fi"

# Tell OpenGrok to initialize (search) indices
cd $OPENGROK_INSTANCE_BASE/opengrok/bin
./OpenGrok deploy 

# Tell OpenGrok to run a preliminary index
cd $OPENGROK_INSTANCE_BASE/opengrok/bin                                                                                                                            
./OpenGrok index

