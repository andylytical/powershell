# Windows Powershell Profile

# Installation

## Enable scripts
- Powershell (as Administrator)
  - `Set-ExecutionPolicy RemoteSigned`
- "Windows Powershell" (as Administrator) #see Notes below for more details
  - `Set-ExecutionPolicy RemoteSigned`

## Install files
- Powershell (as normal user)
  - `Invoke-WebRequest -outfile "${env:USERPROFILE}\setup.ps1" -Uri https://raw.githubusercontent.com/andylytical/powershell/main/setup.ps1`
  - `& "${env:USERPROFILE}\setup.ps1"`
  - `rm "${env:USERPROFILE}\setup.ps1"`

# Powershell Tips / Tricks
- [USERGUIDE.md](USERGUIDE.md)

# Notes
- Two different powershell installs ... https://superuser.com/questions/106360/how-to-enable-execution-of-powershell-scripts#comment2260136_106363
