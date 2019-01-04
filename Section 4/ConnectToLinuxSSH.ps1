# Connecting to a Linux Computer Using SSH

#region PSSession over SSH
$session = New-PSSession -HostName 'tuxsnips' -UserName root

Get-PSSession 

invoke-command -Session $session -ScriptBlock {
    Get-Process | Where-Object {$_.Name -like "*ssh*"}
    $PSVersionTable
}

#endregion PSSession over SSH

#region Enter PSSession over SSH

Enter-PSSession $session

#region Commands in PSSession
Get-Process | Where-Object {$_.Name -like "*ssh*"}


$PSVersionTable
#endregion Commands in PSSession
#endregion Enter PSSession over SSH

#region Exit the Enter-PSSession

Exit-PSSession

#endregion Exit the Enter-PSSession

#region Exit the PSSession

Get-PSSession | Remove-PSSession

#endregion Exit the PSSession