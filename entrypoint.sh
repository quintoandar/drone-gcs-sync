#!/bin/env bash

# disable pathname expansion
set -f

if [ -n "$GOOGLE_APPLICATION_CREDENTIALS" ] ; then
    echo "$GOOGLE_APPLICATION_CREDENTIALS" > creds.json
    gcloud auth activate-service-account --key-file creds.json
fi

if [ "$PLUGIN_DEBUG" = true ] ; then
    set -x
fi

[ -z "$PLUGIN_BUCKET" ] && echo "Missing '\$PLUGIN_BUCKET'!" && exit 1
[ -z "$PLUGIN_TARGET" ] && echo "Missing '\$PLUGIN_TARGET'!" && exit 1
[ -z "$PLUGIN_SOURCE" ] && echo "Missing '\$PLUGIN_SOURCE'!" && exit 1

dryRunArg=""
if [ "$PLUGIN_DRY_RUN" = true ] ; then
    dryRunArg="-n"
fi

deleteArg=""
if [ "$PLUGIN_DELETE" = true ] ; then
    deleteArg="-d"
fi

gsutil -m rsync ${dryRunArg} ${deleteArg} -r ./$PLUGIN_SOURCE gs://${PLUGIN_BUCKET}/${PLUGIN_TARGET}
