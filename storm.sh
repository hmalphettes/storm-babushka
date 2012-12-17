#!/bin/bash
source babushka.sh $*

cd /vagrant
babushka storm.source --debug
