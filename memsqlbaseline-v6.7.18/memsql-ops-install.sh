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

cd $MEMSQL_OPS_PATH/memsql-ops
./memsql-ops start -u root

./memsql-ops agent-list| grep -v ID | awk 'BEGIN { FS = "[ \t]+" } ; { print $2 }'| while read ID
do
    ./memsql-ops memsql-deploy -r Master -a $ID --developer-edition --port 43306 --version-hash db1caffe94b067121423ab3158ed0705bc4b3a11
    ./memsql-ops memsql-deploy -r leaf -a $ID --developer-edition --port 43307 --version-hash db1caffe94b067121423ab3158ed0705bc4b3a11
done

./memsql-ops memsql-update-config --all --key minimum_core_count --value 0
./memsql-ops memsql-update-config --all --key minimum_memory_mb --value 0
./memsql-ops memsql-start --all

export memsql_cluster_start_pid=${!}
wait $memsql_cluster_start_pid

./memsql-ops memsql-stop --all
./memsql-ops stop
