# Tasks

- New Kubernetes cluster was created `hackathon2`, 1 node
- 2 instances of IONOS-S3-EDC were deployed, one as a provider and one as a consumer

We follow the deployment instructions in the [IONOS-S3-EDC](https://github.com/ionos-cloud/edc-ionos-s3/blob/main/deployment/README.md) to install both instances.

To enable deployment of >1 EDC instances on the same kubernetes cluster, we need to use different clones of the source repository, so that conflicts with the terraform state file are avoided. Additionally, we have to configure a different namespace for each instance. We also use different name for vault.

After deployment of both connectors, we note the public IPs that were assigned to the services, which we will need for the following steps. We also create a `.env` configuration file, containing the IPs and source and destination S3 buckets, which will be needed for the bash scripts.

```bash
# external IPs
CONSUMER_IP=1.2.3.4
PROVIDER_IP=2.3.4.5

# buckets
export CONSUMER_BUCKET=hackathon2-consumer-bucket
export PROVIDER_BUCKET=hackathon2-provider-bucket
```

Both EDCs are connected to different DCD users within the same DCD account. The IONOS_TOKEN and S3 access and secret keys are pointed to the same user for each of the 2 instances.

To make sure EDCs are running correctly, we call the `/api/check/health` endpoints and see if a valid response is returned.

```bash
# healthcheck
curl http://$PROVIDER_IP:8181/api/check/health
curl http://$CONSUMER_IP:8181/api/check/health
```