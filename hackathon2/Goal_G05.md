# Quick how-to to create an EDC Extension

This document explains how to create a simple extension in order to connect to the POSSIBLE-X Catalago.

## Requirements

- java 17
- gradle

## Steps

- Create a folder;
- Clone the EDC's Samples [repository](https://github.com/eclipse-edc/Samples);
```
git clone https://github.com/eclipse-edc/Samples.git
```
- Inside the folder `basic`, copy the `possible-extension` folder

## Suggestion

- Open the `PossibleApiController` java class;
- Create an hardcoded object to be sent to the POSSIBLE-X catalog;
- Succeeded in calling the POSSIBLE-X Frauenhofer Fokus federated catalog;

## Building and running

- Building (be sure to be inside the `possible-extension` folder)
```
./gradlew clean basic:possible-extension:build
```

- Running the extension
```
java -jar basic/possible-extension/build/libs/connector-possible.jar
```

- Calling the extension with curl
```bash
curl -i http://localhost:8181/api/registerCatalog
```