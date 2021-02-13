#!/bin/bash
ipSonar=10.0.0.2:9000
ipJenkins=10.0.0.3:8080
token=$(curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "name=WindowsTokenFinal" -u admin:admin $ipSonar/api/user_tokens/generate | jq -r '.token' | xargs)
COOKIEJAR="$(mktemp)"
CRUMB=$(curl -u "admin:admin" --cookie-jar "$COOKIEJAR" "http://"$ipJenkins"/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,%22:%22,//crumb)")
curl -X POST -u "admin:admin" --cookie "$COOKIEJAR" -H "$CRUMB" "http://"$ipJenkins"/credentials/store/system/domain/_/createCredentials" --data-urlencode 'json={"": "0","credentials": {"scope": "GLOBAL","id": "WindowsAutoToken","description": "Automatically generated sonar token from windows","secret": "'"$token"'", "$class": "org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl"}}'
