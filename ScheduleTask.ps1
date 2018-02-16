$xml_path = (Get-ChildItem ".\" "Battery Monitor.xml").FullName
Register-ScheduledTask -Xml (get-content "$xml_path" | out-string) -TaskName "Battery Monitor" -User $env:USERNAME