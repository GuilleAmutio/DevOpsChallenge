# DevOps Challenge

### Definition
The goal of this challenge consists of two parts.
1. Install-dev-env.ps1: A script that will install all the tools needed for this challenge: Chocolatey, Visual Studio Code, Docker, Git and WSL
2. Setup-project.ps1: A script that will create a Visual Studio Code container with your local repository, a Jenkins with a predefined pipeline container and a SonarQube container. Each time a commit is done on the Visual Studio Code container (On to the Deploy branch), it will trigger the Jenkins running. Jenkins and SonarQube configuration is automated.

### How it works
1. The Install-dev-env.ps1 script will first check if Chocolatey is installed, if it´s not installed, it will install it and continue the execution of the script. Will check if the rest of the tools are installed and, if not, will install it. It will also check that the Visual Studio Code has the Remote-containers plugin.
2. The Setup-project.ps1 will first check if the path called is a valid git repository. It will also start Docker and start creating the SonarQube and Jenkins container, once these container can recieve petitions, it will configure the connection between these two. For the Visual Studio Code container will download the folder .devcontainer and the post-commit githook of this repository. The post-commit will notify Jenkins when commit is done and will trigger a pipeline.

### How to use
By default, Jenkins and SonarQube will run on the ports 8080 and 9000, respecivtively. If you want to modify this ports check the section below "How to customize".
If you´re going to run it on the ports by default, just download into the folder where your local repository is and run the script with the repository path, like:

![path](https://user-images.githubusercontent.com/56632305/107864615-3760bd00-6e5e-11eb-9b93-431493a90661.PNG)

```.\setup-project.ps1 .\my-local-repository```

The pipeline that the script created will attempt to use the Jenkinsfile located on /my-local-repo/Jenkins/challenge/Jenkinsfile.

### How to customize


