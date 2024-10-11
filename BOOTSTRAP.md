# Bootstrap repository clone

## Linux

- Install Git Credential Manager:
  ```bash
  REPO=tachylatus/my-setup
  BRANCH=main
  FILEPATH=linux/install_gitcredentialmanager.sh
  URL=https://raw.githubusercontent.com/$REPO/refs/heads/$BRANCH/$FILEPATH
  sh <(curl "-#L" $URL)
  ```
- Configure Git
  ```bash
  git config --global credential.credentialStore cache
  git config --global credential.https://github.com.helper $(which git-credential-manager)
  ```
- Clone repository
  ```bash
  mkdir -p ~/repos/tachylatus
  cd ~/repos/tachylatus
  git clone https://github.com/tachylatus/my-setup.git
  ```

## Windows

- Install Git for Windows
  ```powershell
  winget install -e --id Git.Git
  ```
- Clone repository
  ```powershell
  New-Item -ItemType Directory -Path "$env:USERPROFILE\repos\tachylatus" -Force
  Set-Location "$env:USERPROFILE\repos\tachylatus"
  git clone https://github.com/tachylatus/my-setup.git
  ```
