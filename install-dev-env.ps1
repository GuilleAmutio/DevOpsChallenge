[bool] $restart = $false

$restart

# Install chocolatey
$checkInstallation = powershell choco -v
Write-Host "Searching for Chocolatey installation..." -ForegroundColor Magenta
if(-not($checkInstallation)){
  Write-Host "Chocolatey installation not found." -ForegroundColor Yellow
  Write-Host "Installing Chocolatey..." -ForegroundColor DarkYellow
  Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  choco feature enable -n allowGlobalConfirmation
  Write-Host "Chocolatey installed succesfully." -ForegroundColor Green
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
} else {
  Write-Host "Chocolatey installed succesfully." -ForegroundColor Green
}

# Install WSL engine.
$checkInstallation = powershell wsl -l
Write-Host "Searching for WSL installation..." -ForegroundColor Magenta
if(-not($checkInstallation)){
  Write-Host "WSL installation not found." -ForegroundColor Yellow
  Write-Host "Installing WSL..." -ForegroundColor DarkYellow
  Invoke-WebRequest -Uri "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" -Outfile "wsl_update_x64.msi"
  .\wsl_update_x64.msi /quiet
  rm .\wsl_update_x64.msi
  Write-Host "WSL installed succesfully." -ForegroundColor Green
} else {
  Write-Host "WSL is already installed." -ForegroundColor Green
}

# Second install Docker
$checkInstallation = powershell docker -v
Write-Host "Searching for Docker installation..." -ForegroundColor Magenta
if(-not($checkInstallation)){
  Write-Host "Docker installation not found." -ForegroundColor Yellow
  Write-Host "Installing Docker..." -ForegroundColor DarkYellow
  choco install docker-desktop
  choco install docker-cli
  choco install docker-compose
  Write-Host "Docker installed succesfully." -ForegroundColor Green
} else {
  Write-Host "Docker is already installed." -ForegroundColor Green
    $restart = $true
}

# Install git
$checkInstallation = powershell git --version
Write-Host "Searching for Git installation..." -ForegroundColor Magenta
if(-not($checkInstallation)){
  Write-Host "Git installation not found." -ForegroundColor Yellow
  Write-Host "Installing Git..." -ForegroundColor DarkYellow
  choco install git.install
  Write-Host "Git installed succesfully." -ForegroundColor Green
} else {
  Write-Host "Git is already installed" -ForegroundColor Green
}

# Install VSCode
$checkInstallation = powershell code -v
Write-Host "Searching for Visual Studio Code installation..." -ForegroundColor Magenta
if(-not($checkInstallation)){
  Write-Host "Visual Studio Code installation not found." -ForegroundColor Yellow
  Write-Host "Installing Visual Studio Code..." -ForegroundColor DarkYellow
  choco install vscode.install
  Write-Host "Visual Studio Code installed succesfully."
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
  code --install-extension ms-vscode-remote.remote-containers
} else {
  Write-Host "Visual Studio Code is already installed." -ForegroundColor Green
  code --install-extension ms-vscode-remote.remote-containers
}
