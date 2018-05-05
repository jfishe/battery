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

Toast notications stop if the battery is plugged-in and fully charged.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -computer
{{Fill computer Description}}

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
{{Fill sleep Description}}

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
