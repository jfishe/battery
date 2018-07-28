---
external help file: ScheduleTask_Test-IsOnBattery-help.xml
Module Name: ScheduleTask_Test-IsOnBattery
online version: https://github.com/jfishe/battery/blob/master/docs/Unregister-BatteryMonitor.md
schema: 2.0.0
---

# Unregister-BatteryMonitor

## SYNOPSIS
Unregister-BatteryMonitor remove Task Scheduler App Libary entry for Battery
Monitor.

## SYNTAX

```
Unregister-BatteryMonitor [<CommonParameters>]
```

## DESCRIPTION
Unregister-BatteryMonitor remove Task Scheduler App Libary entry for Battery
Monitor.

## EXAMPLES

### Example 1
```powershell
PS C:\> Unregister-BatteryMonitor

Confirm
Are you sure you want to perform this action?
Performing operation 'Delete' on Target '\Battery Monitor'.
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"):
```

When `Battery Monitor` is registered in Task Scheduler.

### Example 2

```powershell
PS C:\> Unregister-BatteryMonitor
Unregister-ScheduledTask : No MSFT_ScheduledTask objects found with property 'TaskName' equal to
'Battery Monitor'.  Verify the value of the property and retry.
At C:\Users\fishe\Documents\Scripts\battery\ScheduleTask_Test-IsOnBattery\ScheduleTask_Test-IsOnBattery
.psm1:90 char:5
+     Unregister-ScheduledTask -TaskName "Battery Monitor" -Confirm
+     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (Battery Monitor:String) [Unregister-ScheduledTask], CimJobException
    + FullyQualifiedErrorId : CmdletizationQuery_NotFound_TaskName,Unregister-ScheduledTask
```

When `Battery Monitor` is not registered in Task Scheduler.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
