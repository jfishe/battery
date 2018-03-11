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

Try {
    Register-ScheduledTask -Xml (get-content "$xml_path" | out-string) -TaskName "Battery Monitor" -User $env:COMPUTERNAME\$env:USERNAME  -ErrorAction Stop
} Catch  [Microsoft.Management.Infrastructure.CimException] {
    Write-Host "Select Yes to register a new Battery Monitor"
    Write-Host "Select No to Cancel."
    Unregister-ScheduledTask -TaskName "Battery Monitor" -Confirm
    Register-ScheduledTask -Xml (get-content "$xml_path" | out-string) -TaskName "Battery Monitor" -User $env:COMPUTERNAME\$env:USERNAME
}