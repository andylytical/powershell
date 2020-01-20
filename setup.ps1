$DATE = Get-Date -Format yyyyMMdd-HHmmss

# Move old profile aside
get-item $profile | rename-item -newname { $_.Name -replace 'ps1',$curDateTime }

# Install new profile
Invoke-WebRequest -outfile $profile https://raw.githubusercontent.com/andylytical/powershell/master/Microsoft.PowerShell_profile.ps1

## Replace all files in PS1.d
#$psub_dir = Join-Path -Path (get-item $profile).Directory.FullName -ChildPath 'PS1.d'
##echo $psub_dir
#Remove-Item -Path $psub_dir -Recurse -Force -WhatIf
#
## Install custom items in PS1.d
#mkdir $psub_dir
#### TODO - how to install all remote items here?
##          (maybe just git clone, and move)

