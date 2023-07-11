/*
 *  Copyright (c) 2021 Microsoft Corporation
 *
 *  This program and the accompanying materials are made available under the
 *  terms of the Apache License, Version 2.0 which is available at
 *  https://www.apache.org/licenses/LICENSE-2.0
 *
 *  SPDX-License-Identifier: Apache-2.0
 *
 *  Contributors:
 *       Microsoft Corporation - Initial implementation
 *
 */

package org.eclipse.edc.extension.possible;

import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import org.eclipse.edc.spi.monitor.Monitor;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

@Consumes({MediaType.APPLICATION_JSON})
@Produces({MediaType.APPLICATION_JSON})
@Path("/")
public class PossibleApiController {

    private final Monitor monitor;

    public PossibleApiController(Monitor monitor) {
        this.monitor = monitor;
    }

    @GET
    @Path("registerCatalog")
    public String registerCatalog() {
        monitor.info("Received a register request");

        try {
            String catalogUrl = "https://possible.fokus.fraunhofer.de/api/hub/repo/datasets/another-hackathon-dataset";
            URL url = new URL(catalogUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
                reader.close();

                System.out.println("Catalog Response:");
                return response.toString();
            } else {
                System.out.println("Failed to retrieve catalog. Response Code: " + responseCode);
            }
        } catch (Exception ex) {
            System.out.println("Failed to retrieve catalog. Exception: " + ex.getMessage());
        }



        return "{\"response\":\"I'm registered!\"}";
    }
}
