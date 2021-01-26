curl "http://admin:admin@10.0.0.2:9000/api/webhooks/create" -X POST -d "name=jenkins&url=http://10.0.0.3:8080/sonarqube-webhook/"
