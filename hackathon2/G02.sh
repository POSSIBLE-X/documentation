#!/bin/bash

# load config
source .G02-config

# healthcheck
curl -s http://$PROVIDER_IP:8181/api/check/health|jq '.'
curl -s http://$CONSUMER_IP:8181/api/check/health|jq '.'

# create the asset
ASSET_ID=$(pwgen -N1 12)
# ASSET_ID=assetId
echo "Creating asset ID='$ASSET_ID' ..."
curl --header 'X-API-Key: password' \
-d '{
           "asset": {
             "properties": {
               "asset:prop:id": "'$ASSET_ID'",
               "asset:prop:name": "product description",
               "asset:prop:contenttype": "application/json"
             }
           },
           "dataAddress": {
             "properties": {
               "bucketName": "'$PROVIDER_BUCKET'",
               "container": "'$PROVIDER_BUCKET'",
               "blobName": "'$FILENAME'",
               "storage": "s3-eu-central-1.ionoscloud.com",
               "keyName": "'$FILENAME'",
               "type": "IonosS3"
             }
           }
         }' -H 'content-type: application/json' http://$PROVIDER_IP:8182/api/v1/data/assets \
         -s | jq

# create the policy
POLICY_ID=$(pwgen -N1 12)
POLICY_UUID=$(/usr/bin/uuidgen)
echo 'Creating policy ID="'$POLICY_ID'" ...'
curl -d '{
           "id": "'$POLICY_ID'",
           "policy": {
             "uid": "'$POLICY_UUID'",
             "permissions": [
               {
                 "target": "'$ASSET_ID'",
                 "action": {
                   "type": "USE"
                 },
                 "edctype": "dataspaceconnector:permission"
               }
             ],
             "@type": {
               "@policytype": "set"
             }
           }
         }' -H 'X-API-Key: password' \
		 -H 'content-type: application/json' http://$PROVIDER_IP:8182/api/v1/data/policydefinitions

# create the contractoffer
echo ""
echo "Creating contractoffer ..."
CONTRACTOFFER_ID=$(pwgen -N1 12)
curl -d '{
   "id": "'$CONTRACTOFFER_ID'",
   "accessPolicyId": "'$POLICY_ID'",
   "contractPolicyId": "'$POLICY_ID'",
   "criteria": []
 }' -H 'X-API-Key: password' \
 -H 'content-type: application/json' http://$PROVIDER_IP:8182/api/v1/data/contractdefinitions

 # fetch the catalog
 echo "Fetching the catalog ..."
 curl -X POST "http://$CONSUMER_IP:8182/api/v1/data/catalog/request" \
--header 'X-API-Key: password' \
--header 'Content-Type: application/json' \
-d @- <<-EOF
{
  "providerUrl": "http://$PROVIDER_IP:8282/api/v1/ids/data"
}
EOF

# contract negotiation
OFFER_ID="$CONTRACTOFFER_ID:$(/usr/bin/uuidgen)"
echo ""
echo "Negotiating the contract with OFFER_ID=$OFFER_ID ..."
JSON_PAYLOAD=$(cat <<-EOF
{
    "connectorId": "multicloud-push-provider",
    "connectorAddress": "http://$PROVIDER_IP:8282/api/v1/ids/data",
    "protocol": "ids-multipart",
    "offer": {
        "offerId": "$OFFER_ID",
        "assetId": "$ASSET_ID",
        "policy": {
            "uid": "$POLICY_UUID",
            "permissions": [
                {
                "target": "$ASSET_ID",
                "action": {
                    "type": "USE"
                },
                "edctype": "dataspaceconnector:permission"
                }
            ],
            "@type": {
                "@policytype": "set"
            }
        }
    }
}
EOF
)
ID=$(curl -s --header 'X-API-Key: password' -X POST -H 'content-type: application/json' -d "$JSON_PAYLOAD" "http://$CONSUMER_IP:8182/api/v1/data/contractnegotiations" | jq -r '.id')
echo "Contract negitiation ID=$ID. JSON_PAYLOAD=$JSON_PAYLOAD"

# get contract agreement ID
sleep 5
CONTRACT_AGREEMENT_ID=$(curl -X GET "http://$CONSUMER_IP:8182/api/v1/data/contractnegotiations/$ID" \
	--header 'X-API-Key: password' \
    --header 'Content-Type: application/json' \
    -s | jq -r '.contractAgreementId')
echo ""
echo "Contract agreement ID: $CONTRACT_AGREEMENT_ID"

# file transfer
curl -X POST "http://$CONSUMER_IP:8182/api/v1/data/transferprocess" \
    --header "Content-Type: application/json" \
	  --header 'X-API-Key: password' \
    -d @- <<-EOF
    {
        "connectorId": "consumer",
        "connectorAddress": "http://$PROVIDER_IP:8282/api/v1/ids/data",
        "contractId": "$CONTRACT_AGREEMENT_ID",
        "protocol": "ids-multipart",
        "assetId": "$ASSET_ID",
        "managedResources": "true",
        "transferType": {
            "contentType": "application/octet-stream",
            "isFinite": true
        },
        "dataDestination": {
            "properties": {
                "type": "IonosS3",
                "storage":"s3-eu-central-1.ionoscloud.com",
                "bucketName": "$CONSUMER_BUCKET"
            }
        }
    }
EOF