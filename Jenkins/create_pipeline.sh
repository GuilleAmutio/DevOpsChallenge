#!/bin/bash
ipJenkins=10.0.0.3:8080
COOKIEJAR="$(mktemp)"
CRUMB=$(curl -u "admin:admin" --cookie-jar "$COOKIEJAR" "http://$ipJenkins/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,%22:%22,//crumb)")
curl -s -XPOST "http://$ipJenkins/createItem?name=ApplicationChallenge" -u  admin:admin --data-binary @multibranch_model.xml -v --cookie "$COOKIEJAR" -H $CRUMB -H "Content-Type:text/xml"
