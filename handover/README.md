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

### Integration Environment

The integration environment is completly managed in Flux. So everything you need, can be found within the [ionos-infrastructure](https://github.com/POSSIBLE-X/ionos-infrastructure) repository.

## Participants

Under `apps/integration-environment/participants/overlays` you will find every participants configuration.
All participant share the common resources and a base configuration for its own services.
The participants are sorted within the respective use cases.

### Adding Participants

If you want to add a new participant you will have have to perform the following steps:

#### Setup an Ionos Account

For this we utilize terraform. The respective file can be found under `terraform/variables.tf`.
Simply append an entry with the following format

```js
    {
      participant_name = "participant_name"
      use_case = "uc_descriptor"
    }
```

Once committed to origin a github action will run and aplly the terraform changes. Congrats! You now have a namespace of the name `int-{uc_descriptor}-{participant_name}`. In it exists an `ionos-secret` with the dcd credentials.

#### Create a New Participant Overlay

That step is straight forward: Copy an existing participants file into a new file (please store it accordingly within the overlays).
Usually you will now only have to replace the previous use-case-descriptor within the file with the new own. Same with the participant name.

#### Add the Participant to Flux

There exists a file `clusters/possible-x/use-case-envs.yaml`. Simply add an entry there with your new participants file as reference.

### Additional Tools

#### Grafana



#### PG Admin


## Future Improvements

Here is a list of things that may improve the overall

- Remove the Helm Charts entirely - it would be good to migrate the Dev Deployment Process to 


