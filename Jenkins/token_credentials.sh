#!/bin/bash
token=$(curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "name=WindowsTokenFinal" -u admin:admin 10.0.0.2:9000/api/user_tokens/generate | jq -r '.token')
COOKIEJAR="$(mktemp)"
CRUMB=$(curl -u "admin:admin" --cookie-jar "$COOKIEJAR" "http://10.0.0.3:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,%22:%22,//crumb)")
curl -X POST -u "admin:admin" --cookie "$COOKIEJAR" -H "$CRUMB" 'http://10.0.0.3:8080/credentials/store/system/domain/_/createCredentials' --data-urlencode 'json={"": "0","credentials": {"scope": "GLOBAL","id": "WindowsAutoToken","description": "Automatically generated sonar token from windows","secret": "$Token", "$class": "org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl"}}'
