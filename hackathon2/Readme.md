# POSSIBLE Hackathon 2

## Description

This repo contains the scripts generated for the second hackathon of the POSSIBLE-X project.

## Goals


| ID | Keyword | Description | Assigned to participants |
| --- | --- | --- | --- |
| [G01](./Goal_G01.md) | Setup EDC | Setup and deploy the IONOS S3 EDC example in our POSSIBLE IONOS Cloud as two EDC Connector instances (provider and consumer). | Angel, Tsen |
| [G02](./Goal_G02.md) | Test EDC | Test the the EDC connector instances IONOS S3 EDC file transfer example. | Angel |
| [G03](./Goal_G03.md) | Create EDC Script | Create a bash script to execute steps 2 - 4 from a client machine / local dev environment using curl and the EDC Connector API like in the IONOS S3 EDC example and test it. | Angel |
| G04 | Config Cat. Schema | Create and configure a schema within the POSSIBLE-X Catalog the for a “POSSIBLE Data Resource” that Fabian proposed and that has all the needed data structures / properties for storing EDC data assets, EDC policies and EDC contract offers. | Rosanny |
| [G05](./Goal_G05.md) | Create EDC Ext. | Create a custom EDC extension that implements step 5 (“Upload RDF (Data Asset SD“) in the diagram and that uses the POSSIBLE-X Catalog Linked Data API to create a “POSSIBLE Data Resource” with all the necessary metadata based on the contract definition from step 4. Also check the “Additional Infos” section below if that is helpful! Try to automatically react to step 4’s completion with the EDC Connector to trigger step 5. If that is not possible, expose a custom API Endpoint (parameter could be the contract offer ID) for triggering step 5 and extend the EDC script from G03 to call the custom API. c.f. GitHub - ionos-cloud/edc-ionos-s3: IONOS S3 Extension for Eclipse Dataspace Connector  | Paulo, Rosanny. The source code for the POSSIBLE-X EDC Extension has been moved into separate [repository](https://github.com/POSSIBLE-X/hackathon3-Extension). |
| G06 | Setup EDC Ext. | Build the EDC extension as a custom EDC Connector Docker image and deploy it to our POSSIBLE IONOS Cloud. | Paulo, Tsen |
| G07 | Test EDC Ext. | Test the EDC extension in combination with the bash script from G03. | Tsen, Angel, Paulo, Rosanny |
| [G08](./Goal_G08.md) | Create Cat. Script | Write a bash script for step 6 and test it out. | Angel, Tsen |

## Known issues
- The EDC-IONOS-S3 extension creates a temporary S3 keys for each file transfer. After the transfer is finished, the key is not deleted. The limit of max 5 S3 keys in IONOS Cloud is reached. In order to do additional file transfers, the S3 keys must be deleted manually.