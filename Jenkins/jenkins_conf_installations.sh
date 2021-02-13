#!/bin/bash
ipJenkins=10.0.0.3:8080
COOKIEJAR="$(mktemp)"
CRUMB=$(curl -u "admin:admin" --cookie-jar "$COOKIEJAR" "http://$ipJenkins/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,%22:%22,//crumb)")
curl -d "script=$(< ./conf_jenkins_sonar.groovy)" -v --cookie "$COOKIEJAR" -H "$CRUMB" -u "admin:admin" "http://$ipJenkins/script"
curl -d "script=$(< ./conf_maven.groovy)" -v --cookie "$COOKIEJAR" -H "$CRUMB" -u "admin:admin" "http://$ipJenkins/script"
