#!/bin/bash

## This scrpt is called by a cron job to connect to the weather API and post the various city data to Postgresql

##------------------------------------------------------
##--- Global Variables ---
##------------------------------------------------------
WORKFOLDER=/media/sf_shared/netstock/postgresql
/$WORKFOLDER/jhb.sh
/$WORKFOLDER/london.sh
/$WORKFOLDER/newyork.sh
