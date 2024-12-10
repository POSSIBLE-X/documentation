# Connector

## Setup and Issues Notes for IONOS S3 Example

### Client Preparation

On the client there some basic steps that need to be done:

1. If not installed, install Git, Helm, Terraform, kubectl
2. Clone the IONOS S3 Example repo 

### Deployment to IONOS

See [README.md](https://github.com/ionos-cloud/edc-ionos-s3/blob/main/deployment/README.md) for details.

Config:
set variables:

* namespace
* kubeconfig
* vaultname
* s3_access_key
* s3_secret_key
* ...endpoint...

### Last Preparations and Checks on the Client

1. Set env vars for the IP addresses of the connectors.
2. Test out the connector availability through their health check entpoints with curl.

See section "Configure the external IPs" in the main [README.md](https://github.com/ionos-cloud/edc-ionos-s3/blob/main/example/file-transfer-multiple-instances/README.md)

### Issues with Parameters and Documentation

