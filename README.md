# Windows Powershell Profile

# Installation
- Powershell (as Administrator)
  - `Set-ExecutionPolicy RemoteSigned`
- Powershell (as normal user)
  - `get-item $profile | rename-item -newname { $_.Name -replace 'ps1',(Get-Date -Format yyyyMMdd-HHmmss) } -whatif`
  - `Invoke-WebRequest -outfile $profile https://raw.githubusercontent.com/andylytical/powershell/master/Microsoft.PowerShell_profile.ps1`
