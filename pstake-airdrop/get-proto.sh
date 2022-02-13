#!/usr/bin/env bash
[ -d src ] || mkdir src
[ -f src/generated ] || mkdir src/generated
[ -d protoc ] || mkdir protoc
[ -f protoc/bin/protoc ] || (curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.17.3/protoc-3.17.3-linux-x86_64.zip && mv protoc-3.17.3-linux-x86_64.zip protoc && unzip -d protoc -o protoc/protoc-3.17.3-linux-x86_64.zip)

if [ ! -d "pStake-airdrop" ] ; then
    git clone https://github.com/persistenceOne/pStake-airdrop.git
fi

proto_files=$(find ./pStake-airdrop/proto/ -path -prune -o -name '*.proto')

for file_path in $proto_files; do
  echo $file_path
  protoc/bin/protoc \
    --plugin=./node_modules/.bin/protoc-gen-ts_proto \
    --ts_proto_opt=esModuleInterop=true \
    --ts_proto_out=./src/generated \
  $file_path \
    -I ./pStake-airdrop/proto \
    -I ./pStake-airdrop/thirdParty/proto 
done

#STEP1: Change the Protopath
#STEP2: Initialize a ts project and install the dependencies 'npm i @cosmjs/proto-signing && npm i @cosmjs/stargate && npm i @cosmjs/tendermint-rpc && npm i ts-proto@v1.84.0'
#STEP3: Run this bash file to generate the proto files