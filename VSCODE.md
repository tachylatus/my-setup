# VSCode

## Extensions

- Ansible [@id:redhat.ansible](vscode:extension/redhat.ansible)
  - Description: Ansible language support
  - Publisher: Red Hat
  - VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=redhat.ansible
- Black Formatter [@id:ms-python.black-formatter](vscode:extension/ms-python.black-formatter)
  - Description: Formatting support for Python files using the Black formatter.
  - Publisher: Microsoft
  - VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=ms-python.black-formatter
- Container Tools [@id:ms-azuretools.vscode-containers](vscode:extension/ms-azuretools.vscode-containers)
  - Description: Makes it easy to create, manage, and debug containerized applications.
  - Publisher: Microsoft
  - VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-containers
- Docker [@id:ms-azuretools.vscode-docker](vscode:extension/ms-azuretools.vscode-docker)
  - Description: Makes it easy to create, manage, and debug containerized applications.
  - Publisher: Microsoft
  - VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker
- HashiCorp Terraform [@id:hashicorp.terraform](vscode:extension/hashicorp.terraform)
  - Description: Syntax highlighting and autocompletion for Terraform
  - Publisher: HashiCorp
  - VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform
- Jinja [@id:wholroyd.jinja](vscode:extension/wholroyd.jinja)
  - Description: Jinja template language support for Visual Studio Code
  - Publisher: wholroyd
  - VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=wholroyd.jinja
- Markdown All in One [@id:yzhang.markdown-all-in-one](vscode:extension/yzhang.markdown-all-in-one)
  - Description: All you need to write Markdown (keyboard shortcuts, table of contents, auto preview and more)
  - Publisher: Yu Zhang
  - VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one
- Markdown Preview Mermaid Support [@id:bierner.markdown-mermaid](vscode:extension/bierner.markdown-mermaid)
  - Description: Adds Mermaid diagram and flowchart support to VS Code's builtin markdown preview
  - Publisher: Matt Bierner
  - VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=bierner.markdown-mermaid
- PowerShell [@id:ms-vscode.powershell](vscode:extension/ms-vscode.powershell)
  - Description: Develop PowerShell modules, commands and scripts in Visual   - Studio Code!
  - Publisher: Microsoft
  - VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell
- Prettier - Code formatter [@id:esbenp.prettier-vscode](vscode:extension/esbenp.prettier-vscode)
  - Description: Code formatter using prettier
  - Publisher: Prettier
  - VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode
- Python [@id:ms-python.python](vscode:extension/ms-python.python)
  - Description: Python language support with extension access points for IntelliSense (Pylance), Debugging (Python Debugger), linting, formatting, refactoring, unit tests, and more.
  - Publisher: Microsoft
  - VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=ms-python.python
- Rainbow CSV [@id:mechatroner.rainbow-csv](vscode:extension/mechatroner.rainbow-csv)
  - Description: Highlight CSV and TSV files, Run SQL-like queries
  - Publisher: mechatroner
  - VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=mechatroner.rainbow-csv
- Remote - SSH [@id:ms-vscode-remote.remote-ssh](vscode:extension/ms-vscode-remote.remote-ssh)
  - Description: Open any folder on a remote machine using SSH and take advantage of VS   - Code's full feature set.
  - Publisher: Microsoft
  - VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh
- ShellCheck [@id:timonwong.shellcheck](vscode:extension/timonwong.shellcheck)
  - Description: Integrates ShellCheck into VS Code, a linter for Shell   - scripts.
  - Publisher: Timon Wong
  - VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=timonwong.shellcheck
- vscode-pdf [@id:tomoki1207.pdf](vscode:extension/tomoki1207.pdf)
  - Description: Display pdf file in VSCode.
  - Publisher: tomoki1207
  - VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=tomoki1207.pdf
- WSL [@id:ms-vscode-remote.remote-wsl](vscode:extension/ms-vscode-remote.remote-wsl)
  - Description: Open any folder in the Windows Subsystem for Linux (WSL) and   - take advantage of Visual Studio Code's full feature set.
  - Publisher: Microsoft
  - VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl
- YAML [@id:redhat.vscode-yaml](vscode:extension/redhat.vscode-yaml)
  - Description: YAML Language Support by Red Hat, with built-in Kubernetes syntax support
  - Publisher: Red Hat
  - VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=redhat.- vscode-yaml

## Settings

Preferences: Open User Settings (JSON)

```json
{
  "chat.commandCenter.enabled": false,
  "editor.rulers": [72, 80, 88, 120],
  "editor.renderWhitespace": "all",
  "github.copilot.enable": {
    "*": false,
    "plaintext": false,
    "markdown": false,
    "scminput": false
  },
  "telemetry.feedback.enabled": false,
  "terminal.integrated.defaultProfile.windows": "Ubuntu (WSL)",
  "terminal.integrated.profiles.windows": {
    "Command Prompt": {
      "path": [
        "${env:windir}\\Sysnative\\cmd.exe",
        "${env:windir}\\System32\\cmd.exe"
      ],
      "args": [],
      "icon": "terminal-cmd"
    },
    "Git Bash": {
      "source": "Git Bash"
    },
    "PowerShell": {
      "source": "PowerShell",
      "icon": "terminal-powershell"
    },
    "Ubuntu (WSL)": {
      "path": "C:\\WINDOWS\\System32\\wsl.exe",
      "args": ["-d", "Ubuntu"]
    }
  },
  "[dockercompose]": {
    "editor.insertSpaces": true,
    "editor.tabSize": 2,
    "editor.autoIndent": "advanced",
    "editor.defaultFormatter": "redhat.vscode-yaml"
  },
  "[github-actions-workflow]": {
    "editor.defaultFormatter": "redhat.vscode-yaml"
  },
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[jsonc]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[markdown]": {
    "editor.defaultFormatter": "yzhang.markdown-all-in-one"
  },
  "[yaml]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  }
}
```
