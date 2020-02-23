# BASH Equivalents
<table>
<tr><th>BASH</th>
    <th>Powershell</th>
</tr>
<tr>
    <td>cat $file | less</td>
    <td>gci $filename | more</td>
</tr>
<tr>
    <td>CMD | less</td>
    <td>CMDLET | more</td>
</tr>
<tr>
    <td>CMD | grep</td>
    <td>CMDLET | findstr<br/>
        CMDLET | out-string -stream | sls<br/>
        Note: *sls* is Select-String
    </td>
</tr>
</table>


# Commands / Aliases
<table>
<tr>
    <td>Get-ChildItem</td>
    <td>gci<br/>
        ls<br/>
        dir
    </td>
</tr>
<tr>
    <td>Remove-Item</td>
    <td>ri<br/>
        rm<br/>
        rmdir<br/>
        del<br/>
        erase<br/>
        rd<br/>
    </td>
</tr>
<tr>
    <td>Get-Command</td> <td>gcm<br/>
                             _(just like *which* in Bash)_
                         </td>
</tr>
<tr>
    <td>Get-Content</td> <td>gc<br/>
                             cat<br/>
                             type
                         </td>
</tr>
<tr>
    <td>New-Item</td> <td>ni</td>
</tr>
</table>

# Environment Variables
### List
- `ls env:`
### Create / Modify
- Per Session
  - `$env:myvar = "abc123"`
- Permanent
  - `[Environment]::SetEnvironmentVariable( "Name", "Value", "<OPTION>" )`
    - where *OPTION* is one of:
      - `User` _(per use profile)_
      - `Machine` _(anyone logged into the machine)_
      - `Process` _(temporary, for this session only, same as *$env* syntax above)_
### Delete / Unset
- `remove-item Env:$myvariable`
- `[Environment]::SetEnvironmentVariable( "Name", $null, "<OPTION>" )`

# Splatting
Break long commands into readable chunks by specifying parameters in a hash.
```
$params = @{ 'class' = 'Win32_BIOS';
             'computername'='SERVER-R2';
             'filter'='drivetype=3';
             'credential'='Administrator' }

Get-WmiObject @params
```
### Proxy Functions
Create useful aliases (like in Bash) that pass cmdline parameters onto the underlying command
```
function vbox { vagrant box @Args }
```
#### References
- [Windows PowerShell: Splatting](https://technet.microsoft.com/en-us/library/gg675931.aspx)
- [Split command across mulitple lines](https://stackoverflow.com/questions/2608144/how-to-split-long-commands-over-multiple-lines-in-powershell)
- [Splatting with Hashtables or Arrays](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_splatting?view=powershell-5.1&viewFallbackFrom=powershell-Microsoft.PowerShell.Core)

# Custom Profiles
| Directory Locations | |
| --- | --- |
| Per User  | `$USERPROFLE\Documents\WindowsPowerShell\` |
| All users | `$windir\system32\WindowsPowerShell\v1.0\` |

| Special File Names | (must be in one of the directories above) |
| --- | --- |
| Global | `profile.ps1` |
| Powershell Only | `Microsoft.PowerShell_profile.ps1` |

#### References
- https://blogs.technet.microsoft.com/heyscriptingguy/2012/05/21/understanding-the-six-powershell-profiles/

# Symbolic Links
- `New-Item -ItemType SymbolicLink -Name <SRC> -Target <TGT>`
- `New-Item -itemtype junction -name <SRC> -target <TGT>`

#### References
- https://docs.microsoft.com/en-us/powershell/wmf/5.0/feedback_symbolic

# Getting Help
- `man <cmdlet>`
- `<cmdlet> -?`
- `get-help [-detailed -full -parameter <param-name> -examples]`

# Debugging
```Set-PSDebug -Trace 1```
