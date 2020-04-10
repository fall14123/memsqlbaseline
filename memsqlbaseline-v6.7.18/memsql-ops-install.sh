#!/bin/sh

MEMSQL_VERSION=db1caffe94b067121423ab3158ed0705bc4b3a11

MEMSQL_OPS_DOWNLOAD_PATH=/tmp/memsql_ops.tar.gz
MEMSQL_OPS_PATH=/tmp/memsql-ops

## Install memsql-ops
#OPS_VERSION=6.7.5
#VERSION_URL="http://versions.memsql.com/memsql-ops/$OPS_VERSION"
#OPS_URL=$(curl -s "$VERSION_URL" | jq -r .payload.tar)

OPS_URL="http://download.memsql.com/memsql-ops-6.7.5/memsql-ops-6.7.5.tar.gz"
curl -s $OPS_URL -o $MEMSQL_OPS_DOWNLOAD_PATH

mkdir $MEMSQL_OPS_PATH
tar -xzf $MEMSQL_OPS_DOWNLOAD_PATH -C $MEMSQL_OPS_PATH --strip-components 1
rm -rf $MEMSQL_OPS_DOWNLOAD_PATH
