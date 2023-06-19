# Windows Powershell Profile

# Installation
- Powershell (as Administrator)
  - `Set-ExecutionPolicy RemoteSigned`
- "Windows Powershell" (as Administrator) #see Notes below for more details
  - `Set-ExecutionPolicy RemoteSigned`
- Powershell (as normal user)
  - `get-item $profile | rename-item -newname { $_.Name -replace 'ps1',(Get-Date -Format yyyyMMdd-HHmmss) } -whatif`
  - `Invoke-WebRequest -outfile $profile https://raw.githubusercontent.com/andylytical/powershell/master/Microsoft.PowerShell_profile.ps1`

# Powershell Tips / Tricks
- [USERGUIDE.md](USERGUIDE.md)

# Notes
- Two different powershell installs ... https://superuser.com/questions/106360/how-to-enable-execution-of-powershell-scripts#comment2260136_106363
