# Self Descriptions

The catalog supports the following self description types:

- Data Resources (core type and DCAT compliant)
- Service Offering
- Legal Person


## Data Resources

!!! Reference

    [Gaia-X Specification about Data Resources](https://gaia-x.gitlab.io/policy-rules-committee/trust-framework/resource_and_subclasses/#data-resource)  
    [Gaia-X Service Characteristics](https://gitlab.com/gaia-x/technical-committee/service-characteristics/-/blob/develop/single-point-of-truth/yaml/gax-trust-framework/gax-resource/data-resource.yaml)


!!! example "Example Data Resource"

    ```turtle
    @prefix dcat:   <http://www.w3.org/ns/dcat#> .
    @prefix dct:    <http://purl.org/dc/terms/> .

    <https://possible.fokus.fraunhofer.de/set/data/test-dataset>
        a                               dcat:Dataset ;
        dct:description                 "This is an example Dataset 2"@en ;
        dct:description                 "Das ist ein Beispiel-Datensatz"@de ;
        dct:title                       "DCAT-AP 2.1.0 Example Dataset"@en ;
        dct:title                       "DCAT-AP 2.1.0 Beispiel-Datensatz"@de ;
        dcat:distribution               <https://piveau.eu/set/distribution/1> .

    <https://possible.fokus.fraunhofer.de/set/distribution/1>
        a                               dcat:Distribution ;
        dct:license                     <http://dcat-ap.de/def/licenses/gfdl> ;
        dcat:accessURL                  <https://data.europa.eu/api/hub/store/data/test123.csv> .

    ```



``` sh
$ curl --location --request PUT 'http://example.com/resources/legal-person?id=example' --header 'Content-Type: text/turtle' --header 'X-API-Key: yourapikey' 
```


## Legal Person

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
$ curl --location --request PUT 'http://example.com/resources/legal-person?id=example' --header 'Content-Type: text/turtle' --header 'X-API-Key: yourapikey' 
```




## Software Offering

!!! example "Example Legal Person"

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




### Open Issues
- Clarify the type of gax-trust-framework:registrationNumber