#!/bin/bash
USER=OA-WCVP \
REPO=ipni-oa \
GITHUB_API=https://api.github.com/repos/${USER}/${REPO}/releases/latest

ARTIFACT=data
echo "Querying GitHub for the latest $ARCH release" 
LATEST=$(curl -L -s -H 'Accept: application/json' $GITHUB_API) 
LATEST_TAG=$(echo $LATEST_CURL | jq -r '.tag_name') 
echo "Found version $LATEST_TAG" \
LATEST_URL=$(echo $LATEST | jq -r ".assets[] | select(.name | contains(\"$ARTIFACT\")) | .url") 
echo "Downloading curl $LATEST_TAG from $USER" 
curl -vLJO -H 'Accept: application/octet-stream' $LATEST_URL
ls -ltra