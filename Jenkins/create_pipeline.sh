#!/bin/bash
COOKIEJAR="$(mktemp)"
CRUMB=$(curl -u "admin:admin" --cookie-jar "$COOKIEJAR" "http://10.0.0.3:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,%22:%22,//crumb)")
curl -s -XPOST "http://10.0.0.3:8080/createItem?name=ApplicationChallenge" -u  admin:admin --data-binary @multibranch_model.xml -v --cookie "$COOKIEJAR" -H $CRUMB -H "Content-Type:text/xml"
