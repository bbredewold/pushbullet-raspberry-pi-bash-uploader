#!/bin/bash

SECRET="32k5jhv2k3j5hv23kjh5vk31hv51k3hv1l3h5"
DIR="/root/picam/"
DATE=$(date +"%Y-%m-%d_%H%M_%N")
EXT=".jpg"

mkdir -p $DIR
raspistill -vf -hf -t 500 --quality 80 -o $DIR$DATE$EXT

IMGREQ=`curl --header 'Authorization: Bearer '"$SECRET"'' -s -X POST https://api.pushbullet.com/v2/upload-request -d file_name=$DATE$EXT -d file_type=image/jpeg`

PB_UPLOAD_URL=`echo $IMGREQ | jq -r '.upload_url'`
PB_FILE_URL=`echo $IMGREQ | jq -r '.file_url'`

PB_ACCESSKEY="awsaccesskeyid="`echo $IMGREQ | jq -r '.data.awsaccesskeyid'`
PB_ACL="acl="`echo $IMGREQ | jq -r '.data.acl'`
PB_KEY="key="`echo $IMGREQ | jq -r '.data.key'`
PB_SIG="signature="`echo $IMGREQ | jq -r '.data.signature'`
PB_POLICY="policy="`echo $IMGREQ | jq -r '.data.policy'`
PB_CONTENT="content-type="`echo $IMGREQ | jq -r '.data["content-type"]'`
PB_FILE="file=@$DIR$DATE$EXT"

curl -i -X POST $PB_UPLOAD_URL -F $PB_ACCESSKEY -F "$PB_ACL" -F $PB_KEY -F $PB_SIG -F $PB_POLICY -F $PB_CONTENT -F $PB_FILE

echo $PB_FILE_URL;
# Image availible at PB_FILE_URL
