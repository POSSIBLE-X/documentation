# Tasks

We can use the CURLs from the connector [example](https://github.com/ionos-cloud/edc-ionos-s3/blob/main/example/file-transfer-multiple-instances/README.md) to build a bash script which transfers a file between 2 S3 Buckets on IONOS cloud.

A script was created to transfer a file from the consumer bucket to the provider bucket. The script is available [here](./G02.sh). The scripts does the following:
- creates an asset
- creates a policy
- creates a contract offer
- fetches the catalog
- creates a contract agreement
- does contract negotiation
- uploads the file to the consumer bucket
- generates unique IDs for all resources above

