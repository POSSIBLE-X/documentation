# OpenAPI - Eclipse Dataspace Connector

## OpenAPI files

In order to get the latest OpenAPI yaml files required for Swagger UI, follow [these instructions](https://github.com/eclipse-edc/Connector/blob/main/docs/developer/openapi.md).

## Configuration

Set environment variables

```sh
# copy .env-template to .env and set the values of the required parameters
cp .env-template .env

# edit .env and fill in all parameters

# load the configuration
source .env
```

## Docker - #1

To build the docker image, run this command:
```
docker build . --tag edc-connector-swagger-ui:dev2
```

In order to start docker container, run this command:
```
docker run -p $LOCAL_PORT:8080 edc-connector-swagger-ui:dev2
```


## Docker - #2

In order to run Swagger-UI in docker container, run this command:

```
docker run -p $LOCAL_PORT:8080 -e URLS="[{url:'management-api/api-observability.yaml',name:'API-Observability'},{url:'management-api/asset-api.yaml',name:'Asset'},{url:'management-api/catalog-api.yaml',name:'Catalog'},{url:'management-api/contract-agreement-api.yaml',name:'Contract-Agreement'},{url:'management-api/contract-definition-api.yaml',name:'Contract-Definition'},{url:'management-api/data-plane-selector-api.yaml',name:'Data-plane Selector'},{url:'management-api/policy-definition-api.yaml',name:'Policy-Definition'},{url:'management-api/provision-http.yaml',name:'Provision'},{url:'management-api/transfer-process-api.yaml',name:'Transfer-Process'},{url:'management-api/contract-negotiation-api.yaml',name:'Contract-Negotiation'},{url:'control-api/control-plane-api.yaml',name:'Control-Plane API'},{url:'control-api/data-plane-api.yaml',name:'Data-Plane API'},{url:'control-api/transfer-data-plane.yaml',name:'Transfer-Data-Plane API'}]" -v $API_PATH:/usr/share/nginx/html/management-api swaggerapi/swagger-ui
```