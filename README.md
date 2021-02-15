# DevOps Challenge

### Definition
The goal of this challenge consists of two parts.
1. ```Install-dev-env.ps1```: A script that will install all the tools needed for this challenge: Chocolatey, Visual Studio Code, Docker, Git and WSL
2. ```Setup-project.ps1```: A script that will create a Visual Studio Code container with your local repository, a Jenkins with a predefined pipeline container and a SonarQube container. Each time a commit is done on the Visual Studio Code container (On to the Deploy branch), it will trigger the Jenkins running. Jenkins and SonarQube configuration is automated.

### How it works
1. The ```Install-dev-env.ps1``` script will first check if Chocolatey is installed, if it´s not installed, it will install it and continue the execution of the script. Will check if the rest of the tools are installed and, if not, will install it. It will also check that the Visual Studio Code has the Remote-containers plugin.
2. The ```Setup-project.ps1``` will first check if the path called is a valid git repository. It will also start Docker and start creating the SonarQube and Jenkins container, once these container can recieve petitions, it will configure the connection between these two. For the Visual Studio Code container, it will download the folder .devcontainer and the post-commit githook of this repository. The post-commit will notify Jenkins when a commit is done to the deploy branch and will trigger a pipeline.

    Once this script finishes, you will have two containers, Jenkins and SonarQube, running. For the Visual Studio Code container, you will only have to open the repository folder and the VSCode will ask you to reopen that folder in a container, thats all.

### How to use
By default, Jenkins and SonarQube will run on the ports 8080 and 9000, respecivtively. If you want to modify this ports check the section below "How to customize".
If you´re going to run it on the ports by default, just download into the folder where your local repository is and run the script with the repository path, like:

![path](https://user-images.githubusercontent.com/56632305/107864615-3760bd00-6e5e-11eb-9b93-431493a90661.PNG)

```.\setup-project.ps1 .\my-local-repository```

The pipeline that the script created will attempt to use the Jenkinsfile located on /my-local-repo/Jenkins/challenge/Jenkinsfile.

You can try these scripts with [Jump the queue](https://github.com/GuilleAmutio/JumpTheQueue), a repository done specifically to work with this script. It contains the Dockerfiles to deploy the application to Docker once the pipeline finishes, it will run a MySQL, Nginx and a Java containers. Just download the repository and add the scripts.

### How to customize
Sometimes you won´t have available the ports 8080 and 9000, so you might want to change these ports. Change this ports is simple, but you will have to build you own Jenkins image, because the ```Setup-project.ps1``` script use the default image for ports 8080 and 9000, you can locate that image [here](https://hub.docker.com/layers/137473383/guilleamutio/challenge.devops.images/jenkins_challenge/images/sha256-bb39f30106899b0f9841c18012051335f7db267144c2f166322962a0577b7814?context=explore). So, if you want to modify your addresses and ports, just download the Jenkins folder on this repository and follow the guide.

1. The first thing you will have to modify are the variables on ```Setup-project.ps1```, there you will find the ip and ports for each container. 

  ![Variables](https://user-images.githubusercontent.com/56632305/107864842-ce2e7900-6e60-11eb-9f91-c0f61ff88d02.PNG)

2. On second place, you will have to remove the line that goes:

    ```wget https://raw.githubusercontent.com/GuilleAmutio/DevOpsChallenge/main/post-commit -O ${PWD}\${repoPath}\.git\hooks\post-commit```

    You will have to download the Post commit file, modify to point to the desired Jenkins address and add it, manually, to the my-local-repo/.git/hooks/

3. Lastly, as told before, you will have to build a new Jenkins image and modify the line that follows like this, with the new image built:

    ```docker run -d --name challenge_jenkins -v ${PWD}\${repoPath}:/var/jenkins_home/my_repo -v ${PWD}/volumes/jenkins_home:/var/jenkins_home -v   /var/run/docker.sock:/var/run/docker.sock --net netnet --ip ${ipJenkins} -p ${portJenkins}:${portJenkins} guilleamutio/challenge.devops.images:jenkins_challenge```

    But before you build that image you will need to modify the next files on the Jenkins folder:

    3.1. ```Conf_jenkins_sonar.groovy```: Need to modify the SonarQube container address.This file configure the SonarQube scanner tool on Jenkins.

    3.2. ```Create_pipeline.sh```: Need to modify the Jenkins container address. Create the default pipeline configured.

    3.3. ```Jenkins_conf_installations.sh```: Need to modify the Jenkins container address. Invoke ```Conf_jenkins_sonar.groovy``` and the Maven configuration file.

    3.4. ```Token_credentials.sh```: Need to modify the Jenkins and SonarQube container addresses. Create token on SonarQube and add it as a credential to Jenkins.

    3.5. ```Webhook_sonar.sh```:  Need to modify the Jenkins and SonarQube container addresses. Configure the webhook of SonarQube listening to the Jenkins address.

### FAQ

1. **Question** User and password by default?

    **Answer** For both, Jenkins and SonarQube, the default user is ```admin``` and the password is ```admin```
    
