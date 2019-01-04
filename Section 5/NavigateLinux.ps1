# Connect to the remote Linux Machine
Enter-PSSession -HostName TuxSnips -UserName 'scott'

# Check what version of PowerShell we are using
$psversiontable

# pwd is an alias
Get-Location  


# dir and ls are aliases
Get-ChildItem

# Show all files including hidden "ls -a"
Get-ChildItem -Force

# cd is an alias
Set-Location ..

Set-Location ..\..\etc

Set-Location /var/log/tuned

Set-Location ~