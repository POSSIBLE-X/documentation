# Self Descriptions

The catalog supports the following self description types:

- Data Resources (core type and DCAT compliant)
- Software Offering
- Legal Person


## Data Resources

!!! Reference

    [Gaia-X Specification about Data Resources](https://gaia-x.gitlab.io/policy-rules-committee/trust-framework/resource_and_subclasses/#data-resource)  
    [Gaia-X Service Characteristics](https://gitlab.com/gaia-x/technical-committee/service-characteristics/-/blob/develop/single-point-of-truth/yaml/gax-trust-framework/gax-resource/data-resource.yaml)


!!! example "Example Data Resource"

    ```turtle
        @prefix dcat:   <http://www.w3.org/ns/dcat#> .
        @prefix dct:    <http://purl.org/dc/terms/> .
        @prefix gax-core: <http://w3id.org/gaia-x/core#> .
        @prefix gax-trust-framework: <http://w3id.org/gaia-x/gax-trust-framework#> .
        @prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

        <https://possible.fokus.fraunhofer.de/set/data/test-dataset>
            a                                   dcat:Dataset ;
            a                                   gax-trust-framework:DataResource ;
            dct:description                     "This is an example for a Gaia-X Data Resource"@en ;
            dct:title                           "Example Gaia-X Data Resource"@en ;
            gax-trust-framework:producedBy      <https://piveau.io/set/resource/legal-person/some-legal-person-2> ;
            gax-trust-framework:exposedThrough  <http://85.215.193.145:7081/> ;
            gax-trust-framework:containsPII     "false"^^xsd:boolean ;
            dcat:distribution                   <https://possible.fokus.fraunhofer.de/set/distribution/1> .

        <https://possible.fokus.fraunhofer.de/set/distribution/1>
            a                               dcat:Distribution ;
            dct:license                     <http://dcat-ap.de/def/licenses/gfdl> ;
            dcat:accessURL                  <http://85.215.193.145:9192/api/v1/data/assets/test-document_company2> .
    ```

``` sh
$ curl --location --request PUT 'https://possible.fokus.fraunhofer.de/api/hub/repo/test-provider/datasets/origin?originalId=test-data-resource' --header 'Content-Type: text/turtle' --header 'Authorization: Bearer <token>' 
```


## Legal Person


!!! Reference

    [Gaia-X Specification about Legal Person](https://gaia-x.gitlab.io/policy-rules-committee/trust-framework/participant/#legal-person)  
    [Gaia-X Service Characteristics](https://gitlab.com/gaia-x/technical-committee/service-characteristics/-/blob/develop/single-point-of-truth/yaml/gax-trust-framework/gax-participant/legal-person.yaml)



### Example

!!! example "Example Legal Person"

    ```turtle
    @prefix vcard: <http://www.w3.org/2006/vcard/ns#>.
    @prefix gax-trust-framework: <http://w3id.org/gaia-x/gax-trust-framework#>.
    @prefix xsd: <http://www.w3.org/2001/XMLSchema#>.

    <https://possible.fokus.fraunhofer.de/ns/legalperson/example>
        a gax-trust-framework:LegalPerson;
        gax-trust-framework:legalName "Example Limited"^^xsd:string;
        gax-trust-framework:legalForm "Nonprofit corporation";
        gax-trust-framework:description "Example is doing great things"^^xsd:string;
        gax-trust-framework:registrationNumber "DE12345678"^^xsd:string;
        gax-trust-framework:legalAddress [
                                        a vcard:Address;
                                        vcard:country-name "DE"^^xsd:string;
                                        vcard:gps "52.00000,52.00000"^^xsd:string;
                                        vcard:street-address "Example Street 11"^^xsd:string;
                                        vcard:postal-code "11111"^^xsd:string;
                                        vcard:locality "Example City"^^xsd:string
                                    ];
        gax-trust-framework:headquarterAddress [
                                        a vcard:Address;
                                        vcard:country-name "DE"^^xsd:string;
                                        vcard:gps "48.00000,48.00000"^^xsd:string;
                                        vcard:street-address "Sample Way 22"^^xsd:string;
                                        vcard:postal-code "22222"^^xsd:string;
                                        vcard:locality "Sample City"^^xsd:string
                                    ];
        gax-trust-framework:leiCode "abc123"^^xsd:string;
        gax-trust-framework:parentOrganization <https://possible.fokus.fraunhofer.de/ns/legalperson/sample> .
    ```

``` sh
$ curl --location --request PUT 'https://possible.fokus.fraunhofer.de/api/hub/repo/resources/legal-person?id=example' --header 'Content-Type: text/turtle' --header 'Authorization: Bearer <token>' 
```


## Software Offering

!!! Reference

    [Gaia-X Specification about Service Offerings](https://gaia-x.gitlab.io/policy-rules-committee/trust-framework/service_and_subclasses/#service-offering)  
    [Gaia-X Service Characteristics](https://gitlab.com/gaia-x/technical-committee/service-characteristics/-/blob/develop/single-point-of-truth/yaml/gax-trust-framework/gax-service/software-offering.yaml)



!!! example "Example Software Offering"

    ```turtle
    @prefix xsd: <http://www.w3.org/2001/XMLSchema#>.
    @prefix vcard: <http://www.w3.org/2006/vcard/ns#>.
    @prefix gax-core: <http://w3id.org/gaia-x/core#>.
    @prefix gax-trust-framework: <http://w3id.org/gaia-x/gax-trust-framework#>.
    @prefix dcat: <http://www.w3.org/ns/dcat#>.


    <https://possible.fokus.fraunhofer.de/ns/softwareoffering/awesome>
            a gax-trust-framework:SoftwareOffering;
            gax-core:offeredBy <https://possible.fokus.fraunhofer.de/ns/legalperson/example>;
            gax-trust-framework:name "Awesome Software Offering"^^xsd:string;
            gax-trust-framework:termsAndConditions [
                a gax-trust-framework:TermsAndConditions;
                gax-trust-framework:content "https://possible.fokus.fraunhofer/content/terms"^^xsd:anyURI;
                gax-trust-framework:hash "1343456234985623905603249309655"^^xsd:string
            ];
            gax-trust-framework:policy "Strict Policy"^^xsd:string;
            dcat:keyword "service", "awesome", "API" ;
            gax-trust-framework:dataAccountExport [
                a gax-trust-framework:DataAccountExport;
                gax-trust-framework:requestType "API"^^xsd:string;
                gax-trust-framework:accessType "digital"^^xsd:string;
                gax-trust-framework:formatType "application/json"^^xsd:string
            ];
            gax-trust-framework:providedBy <https://possible.fokus.fraunhofer.de/ns/legalperson/example> .

    ```


``` sh
$ curl --location --request PUT 'https://possible.fokus.fraunhofer.de/api/hub/repo/resources/software-offering?id=example' --header 'Content-Type: text/turtle' --header 'Authorization: Bearer <token>' 
```


## POSSIBLE Data Resource

This is a draft idea how a data resource that connects to EDC might look like.

!!! example "Example Data Resource for POSSIBLE"

    ```turtle
    @prefix dcat:   <http://www.w3.org/ns/dcat#> .
    @prefix dct:    <http://purl.org/dc/terms/> .
    @prefix gax-core: <http://w3id.org/gaia-x/core#> .
    @prefix gax-trust-framework: <http://w3id.org/gaia-x/gax-trust-framework#> .
    @prefix possible-x: <https://possible-gaia-x.de/ns/#> .
    @prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

    <https://possible.fokus.fraunhofer.de/set/data/test-dataset>
        a                                   dcat:Dataset ;
        a                                   gax-trust-framework:DataResource ;
        dct:description                     "This is an example for a Gaia-X Data Resource"@en ;
        dct:title                           "Example Gaia-X Data Resource"@en ;
        gax-trust-framework:producedBy      <https://piveau.io/set/resource/legal-person/some-legal-person-2> ;
        gax-trust-framework:exposedThrough  <http://85.215.202.146:8282/> ;
        gax-trust-framework:containsPII     "false"^^xsd:boolean ;
        possible-x:edcApiVersion            "1";
        possible-x:contractOfferId          "1:50f75a7a-5f81-4764-b2f9-ac258c3628e2" ;
        possible-x:assetId                  "assetId" ;
        possible-x:protocol                 possible-x:IdsMultipart ;  
        possible-x:hasPolicy                [
                                                a possible-x:Policy ;
                                                possible-x:policyType possible-x:Set ;
                                                possible-x:uid "231802-bb34-11ec-8422-0242ac120002" ;
                                                possible-x:hasPermissions [
                                                    a possible-x:Permission ;
                                                    possible-x:target "assetId" ;
                                                    possible-x:action possible-x:Use ;
                                                    possible-x:edcType "dataspaceconnector:permission" ;
                                                ] ;
                                            ] ;
        dcat:distribution                   <https://possible.fokus.fraunhofer.de/set/distribution/1> .

    <https://possible.fokus.fraunhofer.de/set/distribution/1>
        a                               dcat:Distribution ;
        dct:license                     <http://dcat-ap.de/def/licenses/gfdl> ;
        dcat:accessURL                  <http://85.215.193.145:9192/api/v1/data/assets/test-document_company2> .

    ```

The command below is the example command to upload the data resource above to the catalog. Note that `edcApiVersion`, `contractOfferId`, `assetId`, `protocol` and `hasPolicy` must be synchronized with the values in EDC.
``` sh
$ curl --location --request PUT 'https://possible.fokus.fraunhofer.de/api/hub/repo/catalogues/test-provider/datasets/origin?originalId=hackathon-dataset' \
--header 'Content-Type: text/turtle' \
--header 'Authorization: Bearer <token>' \
--data-raw '@prefix dcat:   <http://www.w3.org/ns/dcat#> .
@prefix dct:    <http://purl.org/dc/terms/> .
@prefix gax-core: <http://w3id.org/gaia-x/core#> .
@prefix gax-trust-framework: <http://w3id.org/gaia-x/gax-trust-framework#> .
@prefix possible-x: <https://possible-gaia-x.de/ns/#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

<https://possible.fokus.fraunhofer.de/set/data/test-dataset>
    a                                   dcat:Dataset ;
    a                                   gax-trust-framework:DataResource ;
    dct:description                     "This is an example for a Gaia-X Data Resource"@en ;
    dct:title                           "Example Gaia-X Data Resource"@en ;
    gax-trust-framework:producedBy      <https://piveau.io/set/resource/some-legal-person/some-legal-person-2> ;
    gax-trust-framework:exposedThrough  <http://85.215.202.146:8282/> ;
    gax-trust-framework:containsPII     "false"^^xsd:boolean ;
    possible-x:edcApiVersion            "1";
    possible-x:contractOfferId          "1:50f75a7a-5f81-4764-b2f9-ac258c3628e2" ;
    possible-x:assetId                  "assetId" ;
    possible-x:protocol                 possible-x:IdsMultipart ;  
    possible-x:hasPolicy                [
                                            a possible-x:Policy ;
                                            possible-x:policyType possible-x:Set ;
                                            possible-x:uid "231802-bb34-11ec-8422-0242ac120002" ;
                                            possible-x:hasPermissions [
                                                a possible-x:Permission ;
                                                possible-x:target "assetId" ;
                                                possible-x:action possible-x:Use ;
                                                possible-x:edcType "dataspaceconnector:permission" ;
                                            ] ;
                                        ] ;
    dcat:distribution                   <https://possible.fokus.fraunhofer.de/set/distribution/1> .

<https://possible.fokus.fraunhofer.de/set/distribution/1>
    a                               dcat:Distribution ;
    dct:license                     <http://dcat-ap.de/def/licenses/gfdl> ;
    dcat:accessURL                  <http://85.215.193.145:9192/api/v1/data/assets/test-document_company2> .
' 
```


### SPARQL Queries Example

You can perform advanced queries via the SPARQL endpoint.

Tip: Use the "Direct SPARQL Access" SPARQL Query Editor https://possible.fokus.fraunhofer.de/ld/sparql/ 

!!! example "Example 1: Get a SaaS Software Offering from a specific provider"

```sparql
SELECT ?s ?n WHERE  {
   ?s a gax-trust-framework:SoftwareOffering .
   ?s gax-trust-framework:ServiceOfferingLocations "SaaS" .
   ?s gax-core:offeredBy <https://possible.fokus.fraunhofer.de/fraunhofer-fokus> .
   ?s gax-trust-framework:name ?n
}
```


!!! example "Example 2: Get a Data Resource with no personal data"

```sparql
SELECT ?s WHERE  {
   ?s a gax-trust-framework:DataResource .
   ?s gax-trust-framework:containsPII "false"^^xsd:boolean .
}
```


!!! example "Example 3: Get All Properties of all Data Resources but Limit Results to 100"

```sparql
PREFIX gaia-x-trust: <http://w3id.org/gaia-x/gax-trust-framework#>

SELECT ?DataResource ?property ?value WHERE {
  ?DataResource a gaia-x-trust:DataResource .
  ?DataResource ?property ?value 
} LIMIT 100
```
