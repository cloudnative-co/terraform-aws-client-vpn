#!/bin/bash

LF=$(printf '\\\012_')
LF=${LF%_}

ENDPOINTID=$(terraform output -raw client-vpn-endpoint-id)
REGION=$(terraform output -raw region)

aws ec2 export-client-vpn-client-configuration --client-vpn-endpoint-id ${ENDPOINTID} --region ${REGION} \
| jq -r ".ClientConfiguration" \
| sed 's/\\n/'"$LF"'/g' \
| sed 's/verify-x509-name .*$//g'

echo "<cert>"
cat aws-client-vpn-client.crt
echo "</cert>"
echo "<key>"
cat aws-client-vpn-client.key
echo "</key>"
