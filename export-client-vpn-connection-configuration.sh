#!/bin/bash

LF=$(printf '\\\012_')
LF=${LF%_}

aws ec2 export-client-vpn-client-configuration --client-vpn-endpoint-id cvpn-endpoint-0484c98a93c32a59c --region ap-northeast-1 \
| jq -r ".ClientConfiguration" \
| sed 's/\\n/'"$LF"'/g' \
| sed 's/verify-x509-name aws-client-vpn-server name//g'

echo "<cert>"
cat aws-client-vpn-client.crt
echo "</cert>"
echo "<key>"
cat aws-client-vpn-client.key
echo "</key>"
