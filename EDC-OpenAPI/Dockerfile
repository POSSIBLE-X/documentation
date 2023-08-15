FROM swaggerapi/swagger-ui

ENV URLS="[{url:'management-api/api-observability.yaml',name:'API-Observability'},{url:'management-api/asset-api.yaml',name:'Asset'},{url:'management-api/catalog-api.yaml',name:'Catalog'},{url:'management-api/contract-agreement-api.yaml',name:'Contract-Agreement'},{url:'management-api/contract-definition-api.yaml',name:'Contract-Definition'},{url:'management-api/data-plane-selector-api.yaml',name:'Data-plane Selector'},{url:'management-api/policy-definition-api.yaml',name:'Policy-Definition'},{url:'management-api/provision-http.yaml',name:'Provision'},{url:'management-api/transfer-process-api.yaml',name:'Transfer-Process'},{url:'management-api/contract-negotiation-api.yaml',name:'Contract-Negotiation'}]"

COPY $OPEN_API_PATH/* /usr/share/nginx/html/management-api/

RUN chmod 777 /usr/share/nginx/html/ /etc/nginx/conf.d/ /etc/nginx/conf.d/default.conf /var/cache/nginx/ /var/run/

EXPOSE 8080