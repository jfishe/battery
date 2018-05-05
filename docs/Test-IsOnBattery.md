---
external help file: ScheduleTask_Test-IsOnBattery-help.xml
Module Name: ScheduleTask_Test-IsOnBattery
online version:
schema: 2.0.0
---

# Test-IsOnBattery

## SYNOPSIS
Test-IsOnBattery sends a Toast notification when battery charging/discharging
is outside the optimum range for battery lifetime.

## SYNTAX

```
Test-IsOnBattery [[-computer] <String>] [[-sleep] <Int32>]
```

## DESCRIPTION
Test-IsOnBattery sends a Toast notification when battery charging/discharging
is outside the optimum range for battery lifetime.

A Toast notification is sent when:

* The battery is unplugged below 50%
* The battery is plugged-in above 75%.

Toast notifications stop if the battery is plugged-in and fully charged.

## EXAMPLES

### Example 1
```Powershell
PS C:\> Test-IsOnBattery -sleep 10
```

Issue Toast notification every 10 seconds. Default is 600 seconds.

## PARAMETERS

### -computer
Only tested with `localhost`. For other computers, credentials are likely required.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Localhost
Accept pipeline input: False
Accept wildcard characters: False
```

### -sleep
How long to wait, in seconds, before checking whether batter is plugged,
unplugged or fully charged.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 600
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
