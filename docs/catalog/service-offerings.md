# Service Offerings

The catalog supports the management of Gaia-X compliant Service Offerings.

## About the Date Model

There is ambiguity about the valid data models to be used in Gaia-X. The catalog is build on top and acknowledges only the output of the [Gaia-X Service Characteristics Working Group](https://gaia-x.gitlab.io/technical-committee/service-characteristics-working-group/service-characteristics/){:target="_blank"}. The last version was retrieved on 2024-08-15 and can be accessed [here](../public/gaiax-registry-shape-2024-08-15.ttl){:target="_blank"}. All Service Offerings used and presented here are compliant with that version. 


## A Minimal Example
This is a minimal example of a Service Offering.

!!! info
    This is raw Service Offering. It is not wrapped as a Verifiable Credential or Presentation. The catalog separates credential subjects and credential.


!!! example "Minimal Service Offering"

    ```turtle
    @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
    @prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
    @prefix gx: <https://w3id.org/gaia-x/development#> .
    @prefix pv: <https://piveau.eu/ns/voc#> .
    @prefix schema: <https://schema.org/> .
    @prefix vcard: <http://www.w3.org/2006/vcard/ns#> .

    pv:ExampleServiceOffering
        a gx:ServiceOffering ;
        gx:dataAccountExport [
            a gx:DataAccountExport ;
            gx:accessType "digital" ;
            gx:formatType "pdf" ;
            gx:requestType "email" ;
        ] ;
        gx:dataProtectionRegime "GDPR2016" ;
        gx:endpoint [
            a gx:Endpoint ;
            gx:endpointURL "http://endpoint.com"^^xsd:anyURI ;
            gx:formalDescription "OpenAPI" ;
            gx:standardConformity [
                a gx:StandardConformity ;
                gx:standardReference "https://standard.com"^^xsd:anyURI ;
                gx:title "A Standard" ;
            ] ;
        ] ;
        gx:keyword "data" ;
        gx:keyword "example" ;
        gx:provisionType "public" ;
        gx:providedBy <https://ids.fokus.fraunhofer.de/app/legal-participant.json> ;
        gx:serviceOfferingTermsAndConditions [
            a gx:TermsAndConditions ;
            gx:hash "21324rf34c34f3543f" ;
            gx:url "https://termsandconditions.com/"^^xsd:anyURI ;
        ] ;
        gx:servicePolicy "default:allow intent" ;
        schema:description "This is an example service offering." ;
        schema:name "Example Service Offering" .
    ```


## Storing a Service Offering

``` sh
$ curl --location --request PUT 'https://possible.fokus.fraunhofer.de/api/hub/repo/resources/service-offering?id=example' --header 'Content-Type: text/turtle' --header 'Authorization: Bearer <token>' 
```
You need to add the RDF as payload! A more complete example can be found here as [Turtle](https://possible.fokus.fraunhofer.de/api/hub/repo/resources/service-offering/data-product-designer.ttl) or [JSON-LD](https://possible.fokus.fraunhofer.de/api/hub/repo/resources/service-offering/data-product-designer)

## Retrieving a Service Offering

``` sh
$ curl --location --request PUT 'https://possible.fokus.fraunhofer.de/api/hub/repo/resources/service-offering/example'
```

## Searching in all Service Offerings

``` sh
$ curl --location --request GET 'https://possible.fokus.fraunhofer.de/api/hub/search/search?filter=resource_service-offering'
```


