---
external help file: ScheduleTask_Test-IsOnBattery-help.xml
Module Name: ScheduleTask_Test-IsOnBattery
online version: https://github.com/jfishe/battery/blob/master/docs/Register-BatteryMonitor.md
schema: 2.0.0
---

# Register-BatteryMonitor

## SYNOPSIS
Register-BatteryMonitor Add/replace Task Scheduler App Libary entry for Battery
Monitor.
Battery Monitor will run Test-IsOnBattery at user login.

## SYNTAX

```
Register-BatteryMonitor [<CommonParameters>]
```

## DESCRIPTION
Register-BatteryMonitor Add/replace Task Scheduler App Libary entry for Battery
Monitor.
Battery Monitor will run Test-IsOnBattery at user login.

The CurrentUser specified in `$env:USERNAME` is used to create and run the
function.

## EXAMPLES

### Example 1

```Powershell
PS C:\> Register-BatteryMonitor

TaskPath                                       TaskName                          State
--------                                       --------                          -----
\                                              Battery Monitor                   Ready
```

When Battery Monitor is not registered.

### Example 2

```Powershell
PS C:\> Register-BatteryMonitor
Task Scheduler app already has Battery Monitor registered.
Select Yes to register a new Battery Monitor.
Select No to Cancel.

Confirm
Are you sure you want to perform this action?
Performing operation 'Delete' on Target '\Battery Monitor'.
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"):

TaskPath                                       TaskName                          State
--------                                       --------                          -----
\                                              Battery Monitor                   Ready
```

When Battery Monitor is already registered, un-register with confirmation and
then register Battery Monitor. This is not necessary unless the XML template
for Task Scheduler changes.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
