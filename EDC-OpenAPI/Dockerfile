FROM swaggerapi/swagger-ui

ENV URLS="[{url:'management-api/api-observability.yaml',name:'API-Observability'},{url:'management-api/asset-api.yaml',name:'Asset'},{url:'management-api/catalog-api.yaml',name:'Catalog'},{url:'management-api/contract-agreement-api.yaml',name:'Contract-Agreement'},{url:'management-api/contract-definition-api.yaml',name:'Contract-Definition'},{url:'management-api/data-plane-selector-api.yaml',name:'Data-plane Selector'},{url:'management-api/policy-definition-api.yaml',name:'Policy-Definition'},{url:'management-api/provision-http.yaml',name:'Provision'},{url:'management-api/transfer-process-api.yaml',name:'Transfer-Process'},{url:'management-api/contract-negotiation-api.yaml',name:'Contract-Negotiation'},{url:'control-api/control-plane-api.yaml',name:'Control-Plane API'},{url:'control-api/data-plane-api.yaml',name:'Data-Plane API'},{url:'control-api/transfer-data-plane.yaml',name:'Transfer-Data-Plane API'}]"

COPY $API_PATH/* /usr/share/nginx/html/

RUN chmod 777 /usr/share/nginx/html/ /etc/nginx/conf.d/ /etc/nginx/conf.d/default.conf /var/cache/nginx/ /var/run/

EXPOSE 8080