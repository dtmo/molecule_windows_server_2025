Stop-Service sshd

# Delete host keys
Get-ChildItem -Path $Env:ALLUSERSPROFILE\ssh -Filter *_key* | Remove-Item

Start-Process C:\WINDOWS\system32\Sysprep\sysprep.exe -Wait -ArgumentList "/generalize /oobe /shutdown `"/unattend:C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf\Unattend.xml`" /mode:vm"
