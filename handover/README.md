# Documentation

This piece of documentation aims to help DevOps to make changes and improvements for the Possible-X project.

It has three major sections. The first section will be about the used technologies and approaches.
The second part focuses on the details of the deployment in the Development environment and the Integration Environment.
The final part is a list of suggested improvements and things to consider for future development.

## Basic Building Blocks

Currently the setup for Possible-X consists of the following parts:

- EDC Extension
- EDC Participant Portal
- Main Portal
- Creation Wizard API
- DAPS Service
- DID Service
- Fraunhofer Catalog, which again consists of
  - Piveau Hub Repo
  - Piveau Hub Search
  - Nomralization Service
  - Piveau UI Service
  - Elastic Search
  - Virtuoso

For details about the individual projects, please consult their git repos.

Beyond these basic blocks we introduced some tools for monitoring, convenience and to improve the development experience:

- Grafana
- Prometheus
- Loki
- PGAdmin
- Flux


### A bit of history

From the start we planned to utilize Flux as GitOps tool. What was not entirely hammered out yet was the way we deploy the individual services.
So we started with Helm Charts, as the edc deployment already was deployed that way.

Later we decided to use kustomize for the integratin environment. This difference was never synced back completly to the dev environment. Although, later developments like some common resources (did, catalog, etc.).

## Environments

We have essentially two environments. Once we had a similar environment for presentation purposes, that was called poc/mvd/demo environment. THis env was discontinued after the Integration environment was setup.

### Development Environment

#### Certificate Management

Certificates are stored in 

#### Deployment

The catalog and the did service are deployed via Flux. All other applications are deployed in a similar way using helm charts.

The basic setup is similar for all of these installations:

#### Github Action

You will find a ci.yaml file in the .github/workflows directory.
Each workflow will setup a docker image, in which the code the build and tests are run.
At the end of those steps the image is pushed towards the github container registry and can be used.
The final step of the pipeline (at least for develop) is the push of the new image towards the environment.
This is done within the final action of the pipeline.

As mentioned the setup uses a dockerimage, which can usually be found within the backend directory. In any case the exact file path is referenced within the github actions.

The Dockerfile usually has two images - one for building and testing of the code and one for the actual deployment. The later will extract the relevant files from the former.
One special case is the participant portal - which has a small script within the image generation to install a headless chrome.
Why do we need this? The Participant Portal utilizes Browser Tests using the karma tooling. A special caviat is that this does not work out of the box, by simply installing a chrome. If one does that, the chrome will crash, as it is run as root and that would require a special flag called `no-sandbox`. Luckily this can be configured within the karma.config.js:

```js
  browsers: ['ChromeHeadlessNoSandbox'],
  customLaunchers: {
    ChromeHeadlessNoSandbox: {
      base: 'ChromeHeadless',
      flags: ['--no-sandbox']
    }
  }
```

#### Helm Charts

The helm charts can be found in the deployment/helm directory. The charts are homegrown and should be rather straigth forward (or as straight forward as go templates go).
The values are usually located directly next to helm directory, e.g. in a dev directory. Also additional sealed secrets are stored there.
An exception to rule is the configuration of the consumer and provider EDCs. It includes some secret data, that should not be comited to a public repository. Hence, to this date the required values are stored in an offline repository, that is available amon g the developers.

#### Catalog Deployment

The Fraunhofer Catalog is a rather complex system. Its setup is located in `apps/dev-environment/common/catalog` of the `ionos-infrastructure` repository.

There are a lot of moving parts - but the most crucial are the update of the Shapes, the update of the configuration files and the update of the Piveau UI service

##### Updating Shapes

The shapes are located in the `fh-config` folder and referenced in the configMapGenerator `catalog-config-cm`. This is configured in the catalogs `kustomization.yaml`


##### Updating Config Files

Similar to the shapes the config is stored in the `fh-config` directory and referenced in the `catalog-config-cm`. The exact locations of these config files on the host system can be found in the individual yaml files of the services. Usually the ConfigMap is referenced there as a volume and the individual file is associated via a `volumeMount`.

##### Updating the Piveau UI

For reasons we have a separate workflow to generate the Piveau UI for our system. The process there is somewhat complicated:

There exists a piveau-ui project within the Fraunhofer Gitlab. We have access to this repository via a Personal Access Token - granted from the Fraunhofer Team.

We checked out the referenced project - the relevant branch is the POSSIBLE branch in regard to our project. Beyond that we setup an additional remote within github - the [piveau-ui repository](https://github.com/POSSIBLE-X/piveau-ui).

As a github worklfow requires some changes and because we want specific control for changes, we created a develop branch for that remote.

Now the usual process to update the Piveau UI looks like this:
* We fetch the changes from gitlab locally (the POSSIBLE branch)
* We merge the changes from POSSIBLE into the develop branch
* We push the develop branch to github
* The github workflow builds a new image
* We reference the new image within the `piveau-ui.yaml`

The piveau UI utilizes submodules to reference to the public piveau-ui project. As submodules are rather complicated and error prone, I helped myself with a small workaround: Instead of using the submodule I simply git clone the current state of the project in the correct repository. Up until now this works and it should work in the future as well.


TL;DR - this is the simple script:

```bash
git clone https://gitlab.com/piveau/ui/piveau-ui.git # clone this from gitlab - credentials are given from Fraunhofer
cd piveau-ui
git remote add github https://github.com/POSSIBLE-X/piveau-ui.git # Add the github remote
git fetch --all
git checkout -b develop github/develop # Create a branch develop, that tracks the github branch
git checkout -b POSSIBLE origin/POSSIBLE # Create a branch develop, that tracks the gitlab branch
```

Now you have a repository with two remotes and two branches. One branch tracks the origin (gitlab) and one github.
Now you can do

```bash
git checkout POSSIBLE
git fetch
git pull
git checkout develop
git fetch
git pull
git merge POSSIBLE
git push
```

This will fetch changes from POSSIBLE and merge them into your local develop branch and push them to github


### Integration Environment

The integration environment is completly managed in Flux. So everything you need, can be found within the [ionos-infrastructure](https://github.com/POSSIBLE-X/ionos-infrastructure) repository.


#### Upgrading Certs

The certificates we use are all provisioned by the Let's Encrypt. We simply use the generated secrets.
E.g. the did service is configured with the following
```yaml
args:
  - |
    apk add gettext
    export DBHOST=$(env |grep DIDWEB_DB_SERVICE_HOST|awk -F '=' '{print $2}') 
    envsubst < /app/application-ionos.yaml> /app/application.yaml
    wget https://letsencrypt.org/certs/isrgrootx1.pem -O /certs/letsencryptroot.pem
    cat /certs/tls/tls.crt /certs/letsencryptroot.pem > /certs/cert.pem
    java -jar did-web-service.jar
command:
  - /bin/sh
  - -c
volumeMounts:
  - mountPath: /app/application-ionos.yaml
    name: config
    subPath: did-application.yaml
  - mountPath: /certs/tls
    name: certs
envFrom:
  - secretRef:
      name: appuser.didweb-db.credentials.postgresql.acid.zalan.do
env:
  - name: COMMONCERTPATH
    value: /certs/cert.pem
...      

volumes:
  - secret:
      secretName: did-web-ssl-certificate
    name: certs

```

This takes the did-web-ssl-certificate file and puts them under /certs/tls.
As the services requires the whole cert chain, we retrieve that from letsencrypt.org,
put it into a file and concat those files into /certs/cert.pem.

#### Participants

Under `apps/integration-environment/participants/overlays` you will find every participants configuration.
All participant share the common resources and a base configuration for its own services.
The participants are sorted within the respective use cases.

##### Adding Participants

If you want to add a new participant you will have have to perform the following steps:

###### Setup an Ionos Account

For this we utilize terraform. The respective file can be found under `terraform/variables.tf`.
Simply append an entry with the following format

```js
    {
      participant_name = "participant_name"
      use_case = "uc_descriptor"
    }
```

Once committed to origin a github action will run and aplly the terraform changes. Congrats! You now have a namespace of the name `int-{uc_descriptor}-{participant_name}`. In it exists an `ionos-secret` with the dcd credentials.

###### Create a New Participant Overlay

That step is straight forward: Copy an existing participants file into a new file (please store it accordingly within the overlays).
Usually you will now only have to replace the previous use-case-descriptor within the file with the new own. Same with the participant name.

###### Add the Participant to Flux

There exists a file `clusters/possible-x/use-case-envs.yaml`. Simply add an entry there with your new participants file as reference.

#### Deleting Offers

Once we had the task to remove all offers from the EDC database.
There exist two solutions for this problem:
]
- You simply kill the database, using psql. The EDC will setup the db anew ojn a restart
- You unreference all resources within the `kustomization.yaml` of the participant. This will delete all relevant resources. After flux is done with this, you may revert that change and have a freshly installed environment. Please note that this will neither remove the S3 service nor the Access Keys

#### Reseting Main Portal

Similar to the Offer deletion you may
- Delete the DB on the Postgres Service
- Unreference and rereference DB service to delete the PVC

### Additional Tools

#### Grafana



#### PG Admin

It was asked by the developers to setup a PG Admin environment for the Deployment


## Future Improvements

Here is a list of things that may improve the overall

### Remove the Helm Charts entirely

It would be good to migrate the Dev Deployment Process to the
kustomize approach as well.
The biggest problems here would probably be that there
would be small changes in the setup, as the current status has both
the consumer and the provider edc in the same namespace.

Another challenge might be the PG Admin setup. It retrieves the
DB passwords from the secrets in its namespace. If the namespace
should split up, this might be a little bit more challenging. Maybe a setup with a dedicated service role could be helpful here.
This might be an interesting opportunity to add the database access to the int environment as well.

### Automate the Provisioning of the EDCs

In theory there would be ways to automatically create and setup new Participants for the Int environment.

Here I want to illustrate a possible way to reach that goal. There will still be issues to figure out and all of this requires a solution for autorization for the acceptance process and authentication of the user:

The basic steps are
- setup the S3 Bucket
- create and configure the participant
- communicate relevant credentials (e.g. the IONOS DCD creds)

This could be implemented for example by triggering a git commit on acceptance. The commit could add the relevant entry to the terraform file and add a new participant to the list of participants. For details see the paragraph about adding participant in this doc.

The init job of the participant could be enhanced to send the relevant credentials on creation.

This approach would utilize the existing infrastructure and still allow for a gitops approach.
