#!/usr/bin/env bash

# You don't need Fog in Ruby or some other library to upload to S3 -- shell works perfectly fine
# Based on a modified script from here: http://tmont.com/blargh/2014/1/uploading-to-s3-in-bash

S3KEY="my aws key"
S3SECRET="my aws secret" # pass these in

function putS3
{
  path=$1
  file=$2
  aws_path=$3
  bucket='my-aws-bucket'
  date=$(date +"%a, %d %b %Y %T %z")
  acl="x-amz-acl:public-read"
  content_type='application/x-compressed-tar'
  string="PUT\n\n$content_type\n$date\n$acl\n/$bucket$aws_path$file"
  signature=$(echo -en "${string}" | openssl sha1 -hmac "${S3SECRET}" -binary | base64)
  curl -X PUT -T "$path/$file" \
    -H "Host: $bucket.s3.amazonaws.com" \
    -H "Date: $date" \
    -H "Content-Type: $content_type" \
    -H "$acl" \
    -H "Authorization: AWS ${S3KEY}:$signature" \
    "https://$bucket.s3.amazonaws.com$aws_path$file"
}

for file in "$path"/*; do
  putS3 "$path" "${file##*/}" "/path/on/s3/to/files/"
done
