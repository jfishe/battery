
<#PSScriptInfo

.VERSION 0.2.2

.GUID 858af939-79b0-40c6-8bf7-e72ac5ea1149

.AUTHOR jdfenw@gmail.com

.COMPANYNAME John D. Fisher

.COPYRIGHT Copyright (C) 2018  John D. Fisher

.TAGS

.LICENSEURI https://github.com/jfishe/battery/blob/master/LICENSE.md

.PROJECTURI https://github.com/jfishe/battery

.ICONURI

.EXTERNALMODULEDEPENDENCIES BurntToast

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


#>

#Requires -Module BurntToast





<#

.DESCRIPTION
Create/manage Task Scheduler entry to monitor battery charging and maximize
battery lifetime.

#>
Param()

Function Register-BatteryMonitor {
<#
.Synopsis
Register-BatteryMonitor Add/replace Task Scheduler App Libary entry for Battery
Monitor. Battery Monitor will run Test-IsOnBattery at user login.

.Description
Register-BatteryMonitor Add/replace Task Scheduler App Libary entry for Battery
Monitor. Battery Monitor will run Test-IsOnBattery at user login.

The CurrentUser specified in $env:COMPUTERNAME\$env:USERNAME is used to create
and run the function.
#>

# Update computer name and user name in Task Scheduler XML file
    $xml = $XmlBatteryMonitor
    $xml.Task.Triggers.LogonTrigger.UserId = "$env:COMPUTERNAME\$env:USERNAME"

    Try {
        Register-ScheduledTask -Xml $xml.OuterXml -TaskName "Battery Monitor" -User $env:COMPUTERNAME\$env:USERNAME  -ErrorAction Stop
    } Catch  [Microsoft.Management.Infrastructure.CimException] {
        Write-Host ('Task Scheduler app already has Battery Monitor registered.',
                    'Select Yes to register a new Battery Monitor.',
                    'Select No to Cancel.'
                   ) -Separator "`n"

        Unregister-ScheduledTask -TaskName "Battery Monitor" -Confirm
        Register-ScheduledTask -Xml $xml.OuterXml -TaskName "Battery Monitor" -User $env:COMPUTERNAME\$env:USERNAME  -ErrorAction Stop
    }
}

Function Unregister-BatteryMonitor {
<#
.Synopsis
Unregister-BatteryMonitor remove Task Scheduler App Libary entry for Battery
Monitor.

.Description
Unregister-BatteryMonitor remove Task Scheduler App Libary entry for Battery
Monitor.
#>

    Unregister-ScheduledTask -TaskName "Battery Monitor" -Confirm
}

Function Test-IsOnBattery {
<#
.Synopsis
Test-IsOnBattery sends a Toast notification when battery charging/discharging
is outside the optimum range for battery lifetime.

.Description
Test-IsOnBattery sends a Toast notification when battery charging/discharging
is outside the optimum range for battery lifetime.

A Toast notification is sent when:
* The battery is unplugged below 50%
* The battery is plugged-in above 75%.

Toast notications stop if the battery is plugged-in and fully charged.
#>

    Param([string]$computer = "localhost",
          [int]$sleep = 600)

# Add New-BurntToastNotification
    Import-Module BurntToast -ErrorAction Stop

    Function Test-PowerOnLine{
        Param([string]$computer)
        [BOOL](Get-WmiObject -Class BatteryStatus -Namespace root\wmi -ComputerName $computer).PowerOnLine
    } # end function test-PowerOnLine

    $FullChargedCapacity = [int](Get-WmiObject -Class BatteryFullChargedCapacity -Namespace root\wmi -ComputerName $computer).FullChargedCapacity

    while ($true) {
        $IsPowerOnLine = Test-PowerOnLine($computer)
        $BatteryStatus = (Get-WmiObject -Class BatteryStatus -Namespace root\wmi -ComputerName $computer)

        $iPercent = [int](($BatteryStatus.RemainingCapacity / $FullChargedCapacity * 100 ) % 100)
        $IsCharging = [BOOL]$BatteryStatus.Charging

        If ( (-NOT ($IsPowerOnLine)) -AND ($iPercent -lt 50) ) {
            New-BurntToastNotification -Text "Please Plug In!", 'Batter Charge < 50%!' -UniqueIdentifier 'Test-IsPowerOnLine'
        } ElseIf ((-NOT ($IsCharging)) -AND ($IsPowerOnLine)) {
            Continue
        } ElseIf (($iPercent -gt 75) -AND ($IsPowerOnLine)) {
            New-BurntToastNotification -Text "Please Unplug!", 'Batter Charge > 75%!' -UniqueIdentifier 'Test-IsPowerOnLine'
        }

        Start-Sleep -Seconds $sleep
    }
}
# Workflow BatteryMonitor { 'Workflow' }

[XML]$XmlBatteryMonitor = Data { @'
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.4" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Date>2018-02-11T12:46:52.982696</Date>
    <Author>JOHN-AUD9AR3\fishe</Author>
    <Description>Send Toast notification when battery is unplugged below 50% and plugged above 75%. Do not send notifications when plugged above 99%.</Description>
    <URI>\Battery Monitor</URI>
  </RegistrationInfo>
  <Triggers>
    <LogonTrigger>
      <Enabled>true</Enabled>
      <UserId>%COMPUTERNAME%\%USERNAME%</UserId>
    </LogonTrigger>
  </Triggers>
  <Principals>
    <Principal id="Author">
      <UserId>S-1-5-21-4124979968-6801981-3404956818-1001</UserId>
      <LogonType>InteractiveToken</LogonType>
      <RunLevel>LeastPrivilege</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>false</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>true</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>true</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <DisallowStartOnRemoteAppSession>false</DisallowStartOnRemoteAppSession>
    <UseUnifiedSchedulingEngine>true</UseUnifiedSchedulingEngine>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT0S</ExecutionTimeLimit>
    <Priority>7</Priority>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>Powershell.exe</Command>
      <Arguments>-WindowStyle Hidden -ExecutionPolicy Bypass "Import-Module ScheduleTask_Test-IsOnBattery; Test-IsOnBattery" -RunType $true </Arguments>
    </Exec>
  </Actions>
</Task>
'@
}

Export-ModuleMember -Function Register-BatteryMonitor
Export-ModuleMember -Function Unregister-BatteryMonitor
Export-ModuleMember -Function Test-IsOnBattery
