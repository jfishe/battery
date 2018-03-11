Try {
    Import-Module BurntToast -ErrorAction Stop
    Write-Host "Module BurntToast Installed."
} Catch [System.IO.FileNotFoundException] {
    Write-Host "Installing BurntToast"
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    Install-Module -Scope CurrentUser -Name BurntToast
}

Write-Host "Checking for Updates"
Update-Module BurntToast

$xml_path = (Get-ChildItem ".\" "Battery Monitor.xml").FullName

# Update computer name and user name in Task Scheduler XML file
[xml]$xml = Get-Content $xml_path
$xml.Task.Triggers.LogonTrigger.UserId = "$env:COMPUTERNAME\$env:USERNAME"
$xml_tmp = (New-TemporaryFile | Rename-Item -NewName {$_ -replace 'tmp$', 'xml' } -PassThru).FullName
$xml.Save("$xml_tmp")

Try {
    Register-ScheduledTask -Xml (get-content "$xml_tmp" | out-string) -TaskName "Battery Monitor" -User $env:COMPUTERNAME\$env:USERNAME  -ErrorAction Stop
} Catch  [Microsoft.Management.Infrastructure.CimException] {
    Write-Host "Select Yes to register a new Battery Monitor"
    Write-Host "Select No to Cancel."
    Unregister-ScheduledTask -TaskName "Battery Monitor" -Confirm
    Register-ScheduledTask -Xml (get-content "$xml_tmp" | out-string) -TaskName "Battery Monitor" -User $env:COMPUTERNAME\$env:USERNAME
}

Remove-Item $xml_tmp