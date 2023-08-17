#!/bin/bash -x


env

if [ "${INCOMING_HOOK_BODY}" == "" ] ; then
  exit 0
fi

# Get artifact ID and artifact download URL from the incoming webhook
DOWNLOAD_URL=$(echo "${INCOMING_HOOK_BODY}" | jq -r .download_url | base64 -d)
ARTIFACT_ID=$(echo "${INCOMING_HOOK_BODY}" | jq -r .artifact_id)
# Static 404 files in S3 to be used as default 404 in Netflify
DOWNLOAD_404_HTML_URL="https://scrapinghub-staticfiles.s3.amazonaws.com/website-zyte.com-static-files/404.html"
DOWNLOAD_404_CSS_URL="https://scrapinghub-staticfiles.s3.amazonaws.com/website-zyte.com-static-files/404.css"

# Get created artifact in Shifter & decrompress
wget -O "${ARTIFACT_ID}.tgz" "${DOWNLOAD_URL}"
tar xvzf "${ARTIFACT_ID}".tgz

# Get custom 404 files from S3
wget -O "404.html" "${DOWNLOAD_404_HTML_URL}"
wget -O "404.css" "${DOWNLOAD_404_CSS_URL}"

# Place site content into the right folder
mv "${ARTIFACT_ID}" public
# Place 404 custom files into the right folder
mv 404.* public
