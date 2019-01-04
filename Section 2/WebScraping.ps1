$Uri = 'https://www.techsnips.io/contributors/'
$Contributors = Invoke-WebRequest -Uri $Uri

$Contributors.Links | select href

$Contributors.Images.where({$_.src -like '*contributors*'}) | foreach {
    $Filename = $_.src.split('/')[-1]
    Invoke-WebRequest -Uri "https://techsnips.io/$($_.src)" -OutFile D:\Images\$Filename
}

Get-ChildItem -Path 'D:\Images'