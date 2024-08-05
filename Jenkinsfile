stage("Determine Nexus Repository") {
            steps {
                script {
                    pom = readMavenPom file: "pom.xml";
                    if (pom.version.endsWith("RELEASE")) {
                        env.NEXUS_REPOSITORY = "thirdparty-releases"
                    } else {
                        env.NEXUS_REPOSITORY = "thirdparty-snapshots"
                    }
                    echo "Deploying to Nexus repository: ${env.NEXUS_REPOSITORY}"
                }
            }
        }
