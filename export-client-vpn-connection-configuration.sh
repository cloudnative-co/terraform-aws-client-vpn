#!/bin/bash

LF=$(printf '\\\012_')
LF=${LF%_}

ENDPOINTID=$(terraform output -raw client-vpn-endpoint-id)
REGION=$(terraform output -raw region)
CERTFILE=$(terraform output -raw client-cert-filename)
KEYFILE=$(terraform output -raw client-private-key-filename)

aws ec2 export-client-vpn-client-configuration --client-vpn-endpoint-id ${ENDPOINTID} --region ${REGION} \
| jq -r ".ClientConfiguration" \
| sed 's/\\n/'"$LF"'/g' \
| sed 's/verify-x509-name .*$//g'

echo "<cert>"
cat ${CERTFILE}
echo "</cert>"
echo "<key>"
cat ${KEYFILE}
echo "</key>"
