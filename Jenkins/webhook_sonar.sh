#!/bin/bash
ipSonar=10.0.0.2:9000
ipJenkins=10.0.0.3:8080
curl "http://admin:admin@$ipSonar/api/webhooks/create" -X POST -d "name=jenkins&url=http://$ipJenkins/sonarqube-webhook/"
