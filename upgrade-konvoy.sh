#!/bin/bash

env

command -v jq

if [ $? -ne 0 ]
then
  yum install epel-release -y;
  yum install jq -y;
  yum install bzip2 -y;
  jq --version;
fi

version=$1
github_token=$2

echo $version

curl -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: applicationvnd.github.v3.raw" \
  "https://api.github.com/repos/mesosphere/konvoy/releases/tags/${version}" >> release-info

cat release-info

id=$(grep id release-info | cut -d: -f2 | head -n 1| cut -d, -f1 | tr -d "[:space:]")

echo $id

curl -H "Authorization: token $GITHUB_TOKEN" -H "Accept: applicationvnd.github.v3.raw" "https://api.github.com/repos/mesosphere/konvoy/releases/${id}/assets" | jq '.[] |select(.name | contains("linux")) | select(.name | contains("image") | not)' >> release-url


url=$(grep url release-url | cut -d: -f2- | head -n 1| cut -d, -f1 |tr -d "\"")

echo $url

curl -o konvoy_linux.tar.bz2 -L -H "Authorization: token $github_token" -H "Accept: application/octet-stream" $url

tar -xvf konvoy_linux.tar.bz2

