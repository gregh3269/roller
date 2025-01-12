/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  The ASF licenses this file to You
 * under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.  For additional information regarding
 * copyright in this work, please see the NOTICE file in the top level
 * directory of this distribution.
 */
package org.apache.roller.util;

import java.io.File;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;

import org.apache.derby.drda.NetworkServerControl;
import org.apache.roller.weblogger.business.startup.SQLScriptRunner;


public class DerbyManager {
    private final String databaseDir;
    private final String databaseScriptsDir;
    private final int port;

    public DerbyManager(String databaseDir, String databaseScriptsDir, int port) {
        this.databaseDir = databaseDir;
        this.databaseScriptsDir = databaseScriptsDir;
        this.port = port;
    }

    public void startDerby() throws Exception {
        try {
                System.out.println("==============");
                System.out.println("Starting Derby");
                System.out.println("==============");

                System.setProperty("derby.system.home", databaseDir);

                System.setProperty("derby.drda.portNumber", ""+port);
                System.setProperty("derby.drda.host", "localhost");
                System.setProperty("derby.drda.maxThreads","10");
                //System.setProperty("derby.drda.logConnections","true");
                NetworkServerControl server = new NetworkServerControl();
                server.start(new PrintWriter(System.out));
                
                try {Thread.sleep(2000);} catch (Exception ignored) {}
                System.out.println("Runtime Info: " + server.getRuntimeInfo());

                Class.forName("org.apache.derby.jdbc.ClientDriver");
                Connection conn = DriverManager.getConnection(
                    "jdbc:derby://localhost:" + port + "/rollerdb;create=true","APP", "APP");

                // create roller tables
                SQLScriptRunner runner1 = new SQLScriptRunner(
                    databaseScriptsDir + File.separator + "droptables.sql");
                runner1.runScript(conn, false);
                runner1.runScript(conn, false); // not sure why this is necessary

                SQLScriptRunner runner = new SQLScriptRunner(
                    databaseScriptsDir + File.separator + "derby" + File.separator + "createdb.sql");
                try {
                    runner.runScript(conn, true);
                } catch (Exception ignored) {
                    for (String message : runner.getMessages()) {
                        System.out.println(message);
                    }
                    ignored.printStackTrace();
                }

        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("ERROR starting Derby");
        }
    }

    public void stopDerby() throws Exception {
        try {
                Class.forName("org.apache.derby.jdbc.ClientDriver");
                String driverURL = "jdbc:derby://localhost:" + port + "/rollerdb";
                Connection conn = DriverManager.getConnection(driverURL,"APP", "APP");

                // drop Roller tables
                SQLScriptRunner runner = new SQLScriptRunner(
                    databaseScriptsDir
                        + File.separator + "droptables.sql");
                runner.runScript(conn, false);

                System.out.println("==============");
                System.out.println("Stopping Derby");
                System.out.println("==============");

                try {
                    DriverManager.getConnection(driverURL + ";shutdown=true");
                } catch (Exception ignored) {}

                System.setProperty("derby.system.home", databaseDir);

                // Network Derby
                System.setProperty("derby.drda.portNumber", ""+port);
                System.setProperty("derby.drda.host", "localhost");
                System.setProperty("derby.drda.maxThreads","10");
                //System.setProperty("derby.drda.logConnections","true");
                NetworkServerControl server = new NetworkServerControl();
                server.shutdown();

        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
    }
}