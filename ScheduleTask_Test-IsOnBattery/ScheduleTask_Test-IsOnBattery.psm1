<#PSScriptInfo

.VERSION 0.3.0

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

    $TaskName = 'Battery Monitor'

    $Description = 'Send Toast notification when battery is unplugged below '`
        + '50% and plugged above 75%. Do not send notifications when '`
        + 'FullyCharged.'

    $Argument = '-WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile '`
        + '"Test-IsOnBattery" -RunType $true'


    $TimeSpan = New-TimeSpan -Minutes 5
    $Trigger = New-ScheduledTaskTrigger -RandomDelay $TimeSpan -AtLogOn `
        -User "$env:USERNAME"
    $Action = New-ScheduledTaskAction -Execute 'Powershell.exe' `
        -Argument $Argument

    Try {
        Register-ScheduledTask -Action $Action -Trigger $Trigger `
            -TaskName $TaskName -Description $Description `
            -ErrorAction Stop
    } Catch  [Microsoft.Management.Infrastructure.CimException] {
        Write-Warning -Message `
            ('Task Scheduler app already has Battery Monitor registered.',
              'Select Yes to register a new Battery Monitor.',
              'Select No to Cancel.'
            ) -Separator "`n"

        Unregister-ScheduledTask -TaskName $TaskName -Confirm
        Register-ScheduledTask -Action $Action -Trigger $Trigger `
            -TaskName $TaskName -Description $Description `
            -ErrorAction Stop
    }
}

Function Unregister-BatteryMonitor {

    Unregister-ScheduledTask -TaskName $TaskName -Confirm
}

Function Test-IsOnBattery {

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

Export-ModuleMember -Function Register-BatteryMonitor
Export-ModuleMember -Function Unregister-BatteryMonitor
Export-ModuleMember -Function Test-IsOnBattery
