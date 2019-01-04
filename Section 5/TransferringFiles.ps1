#region SMB Transfer

Copy-Item –Path '\\DATACENTER\FileShare\Demo\SMB_Transfered_Me.txt' –Destination '\\DATACENTER\Demo' 

#endregion SMB Transfer

#region Copy via WS-Man
$session = New-PSSession –ComputerName datacenter -Credential tech\shurst
Get-PSSession 


$FileSource = "C:\Users\Scott\source\WSMan_Transfered_Me.txt"
$RemoteDestination = 'C:\Demo\'

Invoke-Command -Session $session -ScriptBlock {
    Get-ChildItem $Using:RemoteDestination
}

# Direct Copy
Copy-Item –Path $FileSource  –Destination 'C:\Demo\' –ToSession $session

# Copy and Rename
Copy-Item –Path $FileSource  –Destination 'C:\Demo\WSMan_Transfered_Me.bkup.txt' –ToSession $session

Get-PSSession  | Remove-PSSession

#endregion Copy via WS-Man


#region Copy via SSH
# Copy File
$SSHSession = New-PSSession -HostName 'datacenter' -UserName tech\shurst
Get-PSSession

$SSHFileSource = "C:\Users\Scott\source\SSH_Transfered_Me.txt"
$RemoteDestination = 'C:\Demo\'

Copy-Item -path $SSHFileSource -Destination $RemoteDestination -ToSession  $SSHSession

Invoke-Command -Session $SSHSession -ScriptBlock {
    Get-ChildItem $Using:RemoteDestination
}



# Copy Full Directory
Get-ChildItem C:\PowerShell

Invoke-Command -Session $SSHSession -ScriptBlock {
    Get-ChildItem C:\Scripts
}

Copy-Item -Path C:\PowerShell -Destination C:\Scripts\PowerShell  -Recurse  -ToSession  $SSHSession



Get-PSSession  | Remove-PSSession
#endregion Copy via SSH
