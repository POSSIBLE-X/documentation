#!/bin/bash

# Get config from environment variables
source .G02-config

set -e

REQUEST_TIMEOUT=10

# Make health check requests to both connectors

PROVIDER_HEALTH_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://$PROVIDER_IP:8181/api/check/health -m $REQUEST_TIMEOUT)
CONSUMER_HEALTH_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://$CONSUMER_IP:8181/api/check/health -m $REQUEST_TIMEOUT)

if [ $PROVIDER_HEALTH_RESPONSE -ne 200 ]; then
  echo "Provider health check failed."
  echo $PROVIDER_HEALTH_RESPONSE
  exit 1
fi

if [ $CONSUMER_HEALTH_RESPONSE -ne 200 ]; then
  echo "Consumer health check failed." 
  echo $CONSUMER_HEALTH_RESPONSE
  exit 1
fi

# Create the asset

ASSET_ID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
echo "Creating asset ID=\"$ASSET_ID\" ..."

CREATE_ASSET_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST http://$PROVIDER_IP:8182/management/v2/assets \
  -H 'Content-Type: application/json' \
  -H "X-API-Key: password" \
  -d '{
    "@context": {
        "@vocab": "https://w3id.org/edc/v0.0.1/ns/",
        "edc": "https://w3id.org/edc/v0.0.1/ns/",
        "odrl": "http://www.w3.org/ns/odrl/2/"
    },
    "edc:asset": {
        "@id": "'"$ASSET_ID"'",
        "@type": "edc:Asset",
        "edc:properties": {
            "edc:name": "Name",
            "edc:description": "Description",
            "edc:contenttype": "application/json",
            "edc:version": "v1.2.3"
        }
    },
    "edc:dataAddress": {
        "@type": "edc:DataAddress",
        "edc:bucketName": "'"$PROVIDER_BUCKET"'",
        "edc:container": "'"$PROVIDER_BUCKET"'",
        "edc:blobName": "'"$FILENAME"'",
        "edc:keyName": "'"$FILENAME"'",
        "edc:storage": "s3-eu-central-1.ionoscloud.com",
        "edc:name": "'"$FILENAME"'",
        "edc:type": "IonosS3"
    }
}' \
  -m $REQUEST_TIMEOUT)

if [ "$CREATE_ASSET_RESPONSE" != "200" ]; then
  echo "Asset creation failed with response code: $CREATE_ASSET_RESPONSE."
  exit 1
fi

# Create the policy 

POLICY_ID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
echo "Creating policy ID=\"$POLICY_ID\" ..."

CREATE_POLICY_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST http://$PROVIDER_IP:8182/management/v2/policydefinitions \
  -H 'Content-Type: application/json' \
  -H "X-API-Key: password" \
  -d '{
    "@context": {
        "@vocab": "https://w3id.org/edc/v0.0.1/ns/",
        "edc": "https://w3id.org/edc/v0.0.1/ns/",
        "odrl": "http://www.w3.org/ns/odrl/2/"
    },
    "@id": "'"$POLICY_ID"'",
    "edc:policy": {
        "@context": "http://www.w3.org/ns/odrl.jsonld",
        "@type": "odrl:Set",
        "odrl:permission": [
            {
                "odrl:target": "'"$ASSET_ID"'",
                "odrl:action": {
                    "odrl:type": "USE"
                },
                "odrl:edctype": "dataspaceconnector:permission"
            }
        ]
    }
}' \
  -m $REQUEST_TIMEOUT)

if [ "$CREATE_POLICY_RESPONSE" != "200" ]; then
  echo "Policy creation failed with response code: $CREATE_POLICY_RESPONSE."
  exit 1
fi

# Create the contractoffer

CONTRACTOFFER_ID=1

CREATE_CONTRACTOFFER_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST http://$PROVIDER_IP:8182/management/v2/contractdefinitions \
  -H 'Content-Type: application/json' \
  -H "X-API-Key: password" \
  -d '{
    "@context": {
        "@vocab": "https://w3id.org/edc/v0.0.1/ns/",
        "edc": "https://w3id.org/edc/v0.0.1/ns/",
        "odrl": "http://www.w3.org/ns/odrl/2/"
    },
    "@id": "'"$CONTRACTOFFER_ID"'",
    "@type": "edc:ContractDefinition",
    "edc:accessPolicyId": "'"$POLICY_ID"'",
    "edc:contractPolicyId": "'"$POLICY_ID"'",
    "edc:assetsSelector": []
}' \
  -m $REQUEST_TIMEOUT)

if [ "$CREATE_CONTRACTOFFER_RESPONSE" != "200" ] && [ "$CREATE_CONTRACTOFFER_RESPONSE" != "409" ]; then
  echo "Contract offer creation failed with response code: $CREATE_CONTRACTOFFER_RESPONSE."
  exit 1
fi

# Fetch the catalog

echo "Fetching the catalog ..."

FETCH_CATALOG_RESPONSE=$(curl -s -X POST http://$CONSUMER_IP:8182/management/v2/catalog/request \
  -H 'Content-Type: application/json' \
  -H "X-API-Key: password" \
  -d '{
    "@context": {
        "edc": "https://w3id.org/edc/v0.0.1/ns/"
    },
    "providerUrl": "http://'"$PROVIDER_IP"':8281/protocol",
    "protocol": "dataspace-protocol-http"
}' \
  -m $REQUEST_TIMEOUT)

CATALOG_CONTRACTOFFER=$(echo "$FETCH_CATALOG_RESPONSE" | jq '.["dcat:dataset"][0]')

if [ -z "$CATALOG_CONTRACTOFFER" ]; then
  echo "New asset fetch failed."
  exit 1
fi

# Contract negotiation

OFFER_ID=$(echo $CATALOG_CONTRACTOFFER | jq -r '.["odrl:hasPolicy"] | .["@id"]')
echo "Negotiating the contract with OFFER_ID=\"$OFFER_ID\" ..."

contract_negotiations_response=$(curl -s -X POST http://$CONSUMER_IP:8182/management/v2/contractnegotiations \
  -H 'Content-Type: application/json' \
  -H "X-API-Key: password" \
  -d '{
    "@context": {
        "@vocab": "https://w3id.org/edc/v0.0.1/ns/",
        "edc": "https://w3id.org/edc/v0.0.1/ns/",
        "odrl": "http://www.w3.org/ns/odrl/2/"
    },
    "@type": "edc:NegotiationInitiateRequestDto",
    "edc:connectorId": "provider",
    "edc:connectorAddress": "http://'"$PROVIDER_IP"':8281/protocol",
    "edc:consumerId": "consumer",
    "edc:protocol": "dataspace-protocol-http",
    "edc:providerId": "provider",
    "edc:offer": {
        "@type": "edc:ContractOfferDescription",
        "edc:offerId": "'$OFFER_ID'",
        "edc:assetId": "'$(echo $CATALOG_CONTRACTOFFER | jq -r '.["edc:id"]')'",
        "edc:policy":'"$(echo $CATALOG_CONTRACTOFFER | jq '.["odrl:hasPolicy"]')"'
    }
}' \
  -m $REQUEST_TIMEOUT)

if [ $? -ne 0 ]; then
  echo "Contract negotiation failed."
  exit 1
fi

contract_negotiations_id=$(echo $contract_negotiations_response | jq -r '.["@id"]')

# Get contract agreement ID

MAX_RETRIES=10
WAIT_SECONDS=5

for ((i=0; i<$MAX_RETRIES; i++)); do
  echo "Requesting status of negotiation"
  sleep $WAIT_SECONDS
  
  GET_CONTRACT_AGREEMENT_RESPONSE=$(curl -s http://$CONSUMER_IP:8182/management/v2/contractnegotiations/$contract_negotiations_id \
    -H 'Content-Type: application/json' \
    -H "X-API-Key: password" \
    -m $REQUEST_TIMEOUT)

  if [ $? -ne 0 ]; then
    echo "Contract agreement failed."
    exit 1
  fi

  echo $GET_CONTRACT_AGREEMENT_RESPONSE

  STATE=$(echo $GET_CONTRACT_AGREEMENT_RESPONSE | jq -r '.["edc:state"]')

  if [ "$STATE" == "FINALIZED" ]; then
    contract_agreement_id=$(echo $GET_CONTRACT_AGREEMENT_RESPONSE | jq -r '.["edc:contractAgreementId"]')
    echo "Contract agreement ID: $contract_agreement_id is FINALIZED."
    break
  elif [[ "$STATE" == "TERMINATING" || "$STATE" == "TERMINATED" ]]; then
    echo "Contract agreement failed."
    exit 1
  elif [ $i -eq $((MAX_RETRIES-1)) ]; then
    echo "Contract agreement failed." 
    exit 1
  fi
done

# File transfer

file_transfer_response=$(curl -s -X POST http://$CONSUMER_IP:8182/management/v2/transferprocesses \
  -H 'Content-Type: application/json' \
  -H "X-API-Key: password" \
  -d '{
    "@context": {
        "@vocab": "https://w3id.org/edc/v0.0.1/ns/",
        "edc": "https://w3id.org/edc/v0.0.1/ns/",
        "odrl": "http://www.w3.org/ns/odrl/2/"
    },
    "@type": "edc:TransferRequestDto",
    "edc:connectorId": "provider",
    "edc:connectorAddress": "http://'"$PROVIDER_IP"':8281/protocol",
    "edc:contractId": "'"$contract_agreement_id"'",
    "edc:protocol": "dataspace-protocol-http",
    "edc:assetId": "'"$ASSET_ID"'",
    "edc:managedResources": false,
    "edc:dataDestination": {
        "@type": "edc:DataAddress",
        "edc:blobName": "'"$FILENAME"'",
        "edc:bucketName": "'"$CONSUMER_BUCKET"'",
        "edc:container": "'"$CONSUMER_BUCKET"'",
        "edc:keyName": "'"$FILENAME"'",
        "edc:name": "'"$FILENAME"'",
        "edc:storage": "s3-eu-central-1.ionoscloud.com",
        "edc:type": "IonosS3"
    }
}' \
  -m $REQUEST_TIMEOUT)

TRANSFER_PROCESS_ID=$(echo $file_transfer_response | jq -r '.["@id"]')

# Get transfer process status

MAX_RETRIES=30
WAIT_SECONDS=5

for ((i=0; i<$MAX_RETRIES; i++)); do
  echo "Requesting status of transfer ..."
  sleep $WAIT_SECONDS

  GET_TRANSFER_PROCESS_RESPONSE=$(curl -s http://$CONSUMER_IP:8182/management/v2/transferprocesses/$TRANSFER_PROCESS_ID \
    -H 'Content-Type: application/json' \
    -H "X-API-Key: password" \
    -m $REQUEST_TIMEOUT)

  STATE=$(echo $GET_TRANSFER_PROCESS_RESPONSE | jq -r '.["edc:state"]')

  echo $GET_TRANSFER_PROCESS_RESPONSE

  if [ "$STATE" == "COMPLETED" ]; then
    break
  elif [ "$STATE" == "TERMINATING" ]; then
    echo "Transfer failed."
    exit 1
  elif [ $i -eq $((MAX_RETRIES-1)) ]; then
    echo "Transfer failed."
    exit 1 
  fi
done