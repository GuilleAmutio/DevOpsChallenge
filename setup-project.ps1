#Check if the repo is a Git repo
Param ([string]$Par1)
if ($Par1 -eq ''){
  Write-Host "ERROR: Specify the path of local git repository"
  exit -1
} else {
  $repoPath = $Par1
  cd $repoPath
  if(git rev-parse --is-inside-work-tree){
    Write-Host "Repository is valid."
    cd ..
  } else {
    Write-Host "ERROR: Not a valid git repository."
    exit -1
  }
}

#Variables
$addressNetwork="10.0.0.0/16"
$ipSonar="10.0.0.2"
$portSonar="9000"
$ipJenkins="10.0.0.3"
$portJenkins="8080"

#Limit health tries
$limitTries=10
$tries=1

# Initialize Docker
Write-Host "Initializing Docker..."
Start-Process -FilePath ' C:\Program Files\Docker\Docker\Docker Desktop.exe'

# Try pattern Docker engine
DO {
  Write-Host "`rWaiting Docker to be up ($tries out $limitTries attempts)" -ForegroundColor Yellow -NoNewLine
  $IsDockerUp = powershell docker ps
  Start-Sleep -Seconds 5
  $tries++
} WHILE (-not($IsDockerUp) -and ($tries -le ($limitTries+1)))
if($tries -gt $limitTries+1) {
       Write-Host "ERROR: Docker was not running in the expected time" -ForegroundColor Red
       pause
       exit -1
} else {
   Write-Host "`nDocker is up and running" -ForegroundColor Green
}
clear

# Folders VSCode Remote container
mkdir ${PWD}\${repoPath}\.devcontainer
mkdir ${PWD}\${repoPath}\.devcontainer\library-scripts

# Files VSCode Remote Container
wget https://raw.githubusercontent.com/GuilleAmutio/DevOpsChallenge/main/VSCodeRemoteFiles/devcontainer/Dockerfile -O ${PWD}\${repoPath}\.devcontainer\Dockerfile
wget https://raw.githubusercontent.com/GuilleAmutio/DevOpsChallenge/main/VSCodeRemoteFiles/devcontainer/devcontainer.json -O ${PWD}\${repoPath}\.devcontainer\devcontainer.json
wget https://raw.githubusercontent.com/GuilleAmutio/DevOpsChallenge/main/VSCodeRemoteFiles/devcontainer/library-scripts/common-debian.sh -O ${PWD}\${repoPath}\.devcontainer\library-scripts\common-debian.sh
wget https://raw.githubusercontent.com/GuilleAmutio/DevOpsChallenge/main/VSCodeRemoteFiles/devcontainer/library-scripts/docker-debian.sh -O ${PWD}\${repoPath}\.devcontainer\library-scripts\docker-debian.sh

# Remote Commit githook. This file should be modified if Jenkins is running on different address other than 10.0.0.3:8080.
# In that case, this line should be commented. Donwload the post-commit file, modified the desired address and add it to the git/hooks folde ron your git repository
wget https://raw.githubusercontent.com/GuilleAmutio/DevOpsChallenge/main/post-commit -O ${PWD}\${repoPath}\.git\hooks\post-commit
clear

# Initialize Jenkins y Sonar.
Write-Host "Creating Jenkins and Sonarqube containers..."
docker network create --subnet=$addressNetwork netnet
docker run -d --name challenge_sonarqube -v ${PWD}/volumes/sonarqube/conf:/opt/sonarqube/conf -v ${PWD}/volumes/sonarqube/data:/opt/sonarqube/data -v ${PWD}/volumes/sonarqube/extensions:/opt/sonarqube/extensions -v ${PWD}/volumes/sonarqube/logs:/opt/sonarqube/logs --net netnet --ip ${ipSonar} -p ${portSonar}:${portSonar} sonarqube:8-community
Write-Host "SonarQube container created."
# The image Jenkins will work if the addresses and ports are not modified, if you want to modify it you will need to rebuild a Jenkins image.
docker run -d --name challenge_jenkins -v ${PWD}\${repoPath}:/var/jenkins_home/my_repo -v ${PWD}/volumes/jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock --net netnet --ip ${ipJenkins} -p ${portJenkins}:${portJenkins} guilleamutio/challenge.devops.images:jenkins_challenge
Write-Host "Initializing Jenkins. It may take some time..."

# Try pattern Jenkins
$Combination = "admin:admin"
$EncodedCredentials = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($Combination))
$BasicAuthValue = "Basic $EncodedCredentials"
$Headers = @{
	Authorization = $BasicAuthValue
}

$limitTries=30
$tries = 1
$IsJenkinsUp = $false
DO {
    Start-Sleep -Seconds 30
    Write-Host "`rWaiting Jenkins and Sonar to be up and running" -ForegroundColor Yellow -NoNewLine
    $StatusCode
    try {
        $Response = Invoke-WebRequest -Uri http://localhost:${portJenkins}/ -Headers $Headers
        $StatusCode = $Response.StatusCode
        $IsJenkinsUp = $Response.StatusCode -eq "200"
        Write-Host "  Current satus code: $StatusCode" -NoNewLine
    }
    catch {
        $StatusCode = $_.Exception.Response.StatusCode.value__
    }
    $tries++
} WHILE (-not($IsJenkinsUp) -and($tries -le ($limitTries+1)))
if($tries -gt $limitTries+1) {
	Write-Host "ERROR: Jenkins was not running in the expected time" -ForegroundColor Red
	pause
	exit -1
} else {
	Write-Host "`nJenkins is up and running" -ForegroundColor Green
}

# Create Sonar token. Add it to Jenkins credentials. Configure Sonar Scanner. Sonar Webhook. Pipeline creation
Write-Host "Configuring Jenkins and SonarQube..."
docker exec -ti challenge_jenkins /bin/bash -c "cd /usr/share/jenkins; ./token_credentials.sh; ./jenkins_conf_installations.sh; ./webhook_sonar.sh; ./create_pipeline.sh"

clear
Write-Host "Jenkins and SonarQube up and configured."
Write-Host "Open your local git repository folder in VSCode and click on 'Reopen in a container' " -ForegroundColor Yellow -NoNewLine
