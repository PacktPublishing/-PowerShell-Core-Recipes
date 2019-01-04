# Check what version of PowerShell we are using
$psversiontable

# pwd is an alias
Get-Location  


# dir and ls are aliases
Get-ChildItem

# Show all files including hidden "ls -a"
Get-ChildItem -Force

# cd is an alias of Set-Location
Set-Location  .\Downloads
Get-ChildItem

Set-Location ..

# Relative Path
Set-Location ..\..\PowerShell

# Absolute Path
Set-Location C:\Windows

# Shortcut return to the User Home Folder
Set-Location ~