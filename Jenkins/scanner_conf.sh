#!/bin/bash
COOKIEJAR="$(mktemp)"
CRUMB=$(curl -u "admin:admin" --cookie-jar "$COOKIEJAR" "http://10.0.0.3:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,%22:%22,//crumb)")
wget https://github.com/GuilleAmutio/DevOpsChallenge/raw/main/conf_jenkins_sonar.groovy
curl -d "script=$(< ./conf_jenkins_sonar.groovy)" -v --cookie "$COOKIEJAR" -H "$CRUMB" -u "admin:admin" "http://10.0.0.3:8080/script"
