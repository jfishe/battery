try {
    Import-Module BurntToast
    Write-Host "Module BurntToast Installed"
} catch {
    Write-Host "Installing BurntToast"
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    Install-Module -Scope CurrentUser -Name BurntToast
}

$xml_path = (Get-ChildItem ".\" "Battery Monitor.xml").FullName
Register-ScheduledTask -Xml (get-content "$xml_path" | out-string) -TaskName "Battery Monitor" -User $env:USERNAME
