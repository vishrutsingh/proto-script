#!/usr/bin/env bash

[ -d src ] || mkdir src
[ -f src/generated ] || mkdir src/generated
[ -d build ] || mkdir build
[ -f build/gen ] || mkdir build/gen
[ -d protoc ] || mkdir protoc
[ -f protoc/bin/protoc ] || (curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.17.3/protoc-3.17.3-linux-x86_64.zip && mv protoc-3.17.3-linux-x86_64.zip protoc && unzip -d protoc -o protoc/protoc-3.17.3-linux-x86_64.zip)

if [ ! -d "wormhole" ] ; then
    git clone https://github.com/certusone/wormhole.git
fi

proto_files=$(find ./wormhole/proto/ -path -prune -o -name '*.proto')

for file_path in $proto_files; do
  echo $file_path
  protoc/bin/protoc \
    --plugin=./node_modules/.bin/protoc-gen-ts_proto \
    --ts_proto_opt=esModuleInterop=true \
    --ts_proto_out=./src/generated \
    $file_path \
    -I ./wormhole/proto \
    -I ~/regen/regen-ledger/third_party/proto
done

    # --proto_path=src \
    # --js_out=import_style=commonjs,binary:build/gen \