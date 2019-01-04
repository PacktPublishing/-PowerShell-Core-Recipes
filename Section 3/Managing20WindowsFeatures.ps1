# Get this from the PS gallery
# https://www.powershellgallery.com/packages/WindowsCompatibility/1.0.0
Install-Module -Name WindowsCompatibility

Import-WinModule -Name ServerManager
# Manager Windows Features
Get-Command -Module ServerManager

# Use Get-WindowsFeature
Get-WindowsFeature -Computername DC1

# Lets view only installed Features
Get-windowsfeature -Computername DC1 | where-object {$_.'InstallState' -eq 'Installed'}

# Lets install a feature
Get-windowsfeature -Computername DC1 | where-object {$_.'Name' -eq 'XPS-Viewer'}
Install-WindowsFeature -Computername DC1 -Name XPS-Viewer

# Remove a feature
Remove-WindowsFeature -Computername DC1 -Name XPS-Viewer