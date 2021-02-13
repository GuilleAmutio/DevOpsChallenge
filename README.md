# DevOps Challenge

### Definition
The goal of this challenge consists of two parts.
1. Install-dev-env.ps1: A script that will install all the tools needed for this challenge: Chocolatey, Visual Studio Code, Docker, Git and WSL
2. Setup-project.ps1: A script that will create a Visual Studio Code container with your local repository, a Jenkins with a predefined pipeline container and a SonarQube container. Each time a commit is done on the Visual Studio Code container (On to the Deploy branch), it will trigger the Jenkins running. Jenkins and SonarQube configuration is automated.

### How to use

By default, Jenkins and SonarQube will run on the ports 8080 and 9000, respecivtively. If you want to modify this ports check the section below "How to customize".
If you´re going to run it on the ports by default, just download into the folder where your local repository is and run the script with the repository path, like:
![path](https://user-images.githubusercontent.com/56632305/107864615-3760bd00-6e5e-11eb-9b93-431493a90661.PNG)
```.\setup-project.ps1 .\my-local-repository```


