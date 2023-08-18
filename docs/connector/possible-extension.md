# FILE TRANSFER WITH POSSIBLE EXTENSION LOCALLY
### 
This documentatiuon have the objective how to interact with Possible extension

## Requirements
You will need the following:

- IONOS account;
- Java Development Kit (JDK) 17 or higher;
- Linux shell or PowerShell;
- Ionos s3 extension
## Building the project
Follow this [documentation](https://github.com/POSSIBLE-X/possible-x-edc-extension/blob/main/README.md)



## Usage

We will have to call some URL's in order to transfer the file:

### 1) Asset creation for the consumer
- @id (you can put whatever you want, will be use one step 3)
- name (will be sent to the Possible api)
- description (will be sent to the Possible api)


```
 curl -d '{
           "@context": {
             "edc": "https://w3id.org/edc/v0.0.1/ns/"
           },
           "asset": {
             "@id": "hackathonDataSet",
             "properties": {
               "name": "MultiInst Dataset",
               "description": "With this dataset you can do this and that",
               "contenttype": "application/json"
             }
           },
           "dataAddress": {
             "type": "IonosS3",
			 "storage": "s3-eu-central-1.ionoscloud.com",
             "bucketName": "company1",
             "keyName" : "device1-data.csv"
           }
         }' \
  -H 'X-API-Key: password' -H 'content-type: application/json' http://localhost:8182/management/v2/assets
  ```


### 2) Policy creation
- @id (You can put whatever you want, will be use one step 3)

```
curl -d '{
           "@context": {
             "edc": "https://w3id.org/edc/v0.0.1/ns/",
             "odrl": "http://www.w3.org/ns/odrl/2/"
           },
           "@id": "aPolicy1",
           "policy": {
             "@type": "set",
             "odrl:permission": [],
             "odrl:prohibition": [],
             "odrl:obligation": []
           }
         }' \
  -H 'X-API-Key: password' -H 'content-type: application/json' http://localhost:8182/management/v2/policydefinitions

```


### 3) Contract creation

- @id: (You can put whatever you want)
- accessPolicyId: (It's the @ID you inserted in step 2 )
- contractPolicyId: (It's the @ID you inserted in step 2 )
- operandRight: (It's the @ID you inserted in step 1)
```
  curl -d '{
           "@context": {
             "edc": "https://w3id.org/edc/v0.0.1/ns/"
           },
           "@id": "igeneratemypolicyid",
           "accessPolicyId": "aPolicy1",
           "contractPolicyId": "aPolicy1",
           "assetsSelector": [
              {"operandLeft":"https://w3id.org/edc/v0.0.1/ns/id", "operator":"=", "operandRight":"hackathonDataSet"}
           ]
         }' \
  -H 'X-API-Key: password' -H 'content-type: application/json' http://localhost:8182/management/v2/contractdefinitions
```

Now you have associated the asset (step 1) with the policy (step 2) and the Possible Connector sends automatically data to the Possible API :
- asset @id (step 1) = possible-x:assetId 
- asset name (step 1) = dct:title 
- asset description (step 1) =dct:description
- policy @id (step 2) = possible-x:uid 
- contractDefinition @id (step 3)= possible-x:contractOfferId 

[more details](https://github.com/POSSIBLE-X/possible-x-edc-extension/blob/main/extension/src/main/java/org/eclipse/edc/extension/possible/rdf/JenaHandler.java)

```
@prefix dcat: <http://www.w3.org/ns/dcat#> .
@prefix dct:<http://purl.org/dc/terms/> . 
@prefix gax-core: <http://w3id.org/gaia-x/core#> . 
@prefix gax-trust-framework: <http://w3id.org/gaia-x/gax-trust-framework#> . 
@prefix possible-x:          <http://w3id.org/gaia-x/possible-x#> . 
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> . 
			<https://possible.fokus.fraunhofer.de/set/distribution/1> 
			a               
			dcat:distribution ;         
			dct:license     <http://dcat-ap.de/def/licenses/gfdl> ;         
			dcat:accessURL  <xxxxxxx> .  
			<https://possible.fokus.fraunhofer.de/set/data/test-dataset a   gax-trust-framework:DataResource , 
			dcat:Dataset ;         
			dct:description                 "With this dataset you can do this and that"@en ;         
			dct:title                       "MultiInst Dataset"@en ;         
			gax-trust-framework:containsPII                 false ;         
			gax-trust-framework:exposedThrough                 <xxxxxx> ;         
			gax-trust-framework:producedBy  <https://piveau.io/set/resource/legal-person/some-legal-person-2> ;         
			possible-x:assetId              "hackathonDataSet" ;
			possible-x:contractOfferId      "igeneratemypolicyid" ;
			possible-x:edcApiVersion        "0.1.2" ;
			possible-x:hasPolicy            [ a                          possible-x:Policy ;
			possible-x:hasPermissions  [ a                   possible-x:Permission ;
            possible-x:action   possible-x:Use ;
			possible-x:edcType  "dataspaceconnector:permission" ;
			possible-x:target   "hackathonDataSet"
                               ] ;
			possible-x:policyType      possible-x:Set ;
            possible-x:uid             "aPolicy1"
                           ] ;         possible-x:protocol             possible-x:IdsMultipart ;         dcat:distribution
 <https://possible.fokus.fraunhofer.de/set/distribution/1>
```

###  4) Fetching the catalog

```
curl -X POST "http://localhost:9192/management/v2/catalog/request" \
    -H 'Content-Type: application/json' \
    -H 'X-API-Key: password' \
    -d '{
      "@context": {
        "edc": "https://w3id.org/edc/v0.0.1/ns/"
      },
      "providerUrl": "http://localhost:8282/protocol",
      "protocol": "dataspace-protocol-http"
    }'
```

you will receive a result similar to this:

```
result: 
 {
	"@id": "9276d7ac-d752-499d-8dca-69803d5b6eba",
	"@type": "dcat:Catalog",
	"dcat:dataset": {
		"@id": "414754e6-df91-4ab8-b230-3881ab062a27",
		"@type": "dcat:Dataset",
		"odrl:hasPolicy": [
			{
				"@id": "1234:hackathonDataSet:d59d7555-5495-4e6a-8f61-f31c73629d11",
				"@type": "odrl:Set",
				"odrl:permission": [],
				"odrl:prohibition": [],
				"odrl:obligation": [],
				"odrl:target": "hackathonDataSet"
			},
			{
				"@id": "igeneratemypolicyid:hackathonDataSet:2df6d095-600b-4212-ae99-7e337254b2a4",
				"@type": "odrl:Set",
				"odrl:permission": [],
				"odrl:prohibition": [],
				"odrl:obligation": [],
				"odrl:target": "hackathonDataSet"
			}
		],
		"dcat:distribution": [],
		"edc:name": "MultiInst Dataset",
		"edc:description": "With this dataset you can do this and that",
		"edc:id": "hackathonDataSet",
		"edc:contenttype": "application/json"
	},
	"dcat:service": {
		"@id": "af36b239-2e5f-451e-92d8-0740366874b3",
		"@type": "dcat:DataService",
		"dct:terms": "connector",
		"dct:endpointUrl": "http://localhost:8282/protocol"
	},
	"edc:participantId": "possible",
	"@context": {
		"dct": "https://purl.org/dc/terms/",
		"edc": "https://w3id.org/edc/v0.0.1/ns/",
		"dcat": "https://www.w3.org/ns/dcat/",
		"odrl": "http://www.w3.org/ns/odrl/2/",
		"dspace": "https://w3id.org/dspace/v0.8/"
	}
}
``` 

If you see odrl:hasPolicy: you will have this dataSet:
```
"odrl:hasPolicy": [.....,
{
				"@id": "igeneratemypolicyid:hackathonDataSet:2df6d095-600b-4212-ae99-7e337254b2a4",
				"@type": "odrl:Set",
				"odrl:permission": [],
				"odrl:prohibition": [],
				"odrl:obligation": [],
				"odrl:target": "hackathonDataSet"
			}
]
```

you will be see on id "@id": "igeneratemypolicyid:hackathonDataSet:2df6d095-600b-4212-ae99-7e337254b2a4"

- igeneratemypolicyid - is equal step 3 @id	
- hackathonDataSet - id from asset step 1 @id
- 2df6d095-600b-4212-ae99-7e337254b2a4 - is generated by the EDC

###  5) Contract negotiation
Copy the `policy{ @id` from the response of the previous curl into this curl and execute it.

```
curl --location --request POST 'http://localhost:9192/management/v2/contractnegotiations' \
--header 'X-API-Key: password' \
--header 'Content-Type: application/json' \
--data-raw '{
	"@context": {
    "edc": "https://w3id.org/edc/v0.0.1/ns/",
    "odrl": "http://www.w3.org/ns/odrl/2/"
  },
  "@type": "NegotiationInitiateRequestDto",
  "connectorId": "provider",
  "connectorAddress": "http://localhost:8282/protocol",
  "protocol": "dataspace-protocol-http",
  "offer": {
    "offerId": "<REPLACE WHERE>",
    "assetId": "hackathonDataSet",
    "policy": {"@id":"<REPLACE WHERE>",
			"@type": "odrl:Set",
			"odrl:permission": {
				"odrl:target": "1",
				"odrl:action": {
					"odrl:type": "USE"
				}
			},
			"odrl:prohibition": [],
			"odrl:obligation": [],
			"odrl:target": "hackathonDataSet"}
  }
}'
```
Note: copy the `id` field;

### 6) Contract agreement

```
curl -X GET "http://localhost:9192/management/v2/contractnegotiations/39b0ba56-075c-48a8-a7d4-1e66197460cf" \
	--header 'X-API-Key: password' \
    --header 'Content-Type: application/json' 
```
You will have an answer like the following:
```
{
	"@type": "edc:ContractNegotiationDto",
	"@id": "a88180b3-0d66-41b5-8376-c91d8253afcf",
	"edc:type": "CONSUMER",
	"edc:protocol": "dataspace-protocol-http",
	"edc:state": "FINALIZED",
	"edc:counterPartyAddress": "http://localhost:8282/protocol",
	"edc:callbackAddresses": [],
	"edc:contractAgreementId": "1:1:5c0a5d3c-69ea-4fb5-9d3d-e33ec280cde9",
	"@context": {
		"dct": "https://purl.org/dc/terms/",
		"edc": "https://w3id.org/edc/v0.0.1/ns/",
		"dcat": "https://www.w3.org/ns/dcat/",
		"odrl": "http://www.w3.org/ns/odrl/2/",
		"dspace": "https://w3id.org/dspace/v0.8/"
	}
}
```
Note: copy the `contractAgreementId` field;

### 7) Transfering the asset
```
curl -X POST "http://localhost:9192/management/v2/transferprocesses" \
    --header "Content-Type: application/json" \
	--header 'X-API-Key: password' \
    --data '{	
				"@context": {
					"edc": "https://w3id.org/edc/v0.0.1/ns/"
					},
				"@type": "TransferRequestDto",
                "connectorId": "consumer",
                "connectorAddress": "http://localhost:8282/protocol",
				"protocol": "dataspace-protocol-http",
                "contractId": "<REPLACE WHERE>",
                "assetId": "hackathonDataSet",
				"dataDestination": { 
					"type": "IonosS3",
					"storage":"s3-eu-central-1.ionoscloud.com",
					"bucketName": "yourcompany",
					"keyName" : "device1-data.csv"
				
				
				},
				"managedResources": false
        }'	
```

Note: copy the `id` field to do the deprovisioning;

Accessing the bucket on the IONOS S3, you will see the `device1-data.csv` file.

8) Deprovisioning 

```
curl -X POST -H 'X-Api-Key: password' "http://localhost:9192/management/v2/transferprocess/{<ID>}/deprovision"
```

Note: this will delete the IONOS S3 token from IONOS Cloud.
