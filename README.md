# Generate Toast notifications when battery is outside 50 - 75%

The [BurntToast](https://www.powershellgallery.com/packages/BurntToast)
PSGallery module provides Toast notifications when the computer is unplugged
below 50% or plugged above 75%. This range maximizes the available charging
cycles for the laptop battery, supposedly 2000 versus 200, for charging from
0 - 100% regularly.

* The best approach is to fully charge the battery and then remove from the
  laptop to prevent degradation from higher temperature operation.
* Second best is to always leave the laptop plugged in, since modern laptops
  will stop charging at 100%. There is some risk of higher temperature
  degradation of the battery.

If the laptop is left plugged in and laptop stops charging, Toast notifications
will not be issued since fully charged is a reasonably good condition. Between
75 and fully charged, toast notifications will repeat every 10 minutes.

## Installation

[ScheduleTask.ps1](file://./ScheduleTask.ps1) creates a Task Scheduler entry
for the current user, called *Battery Monitor*. *Battery Monitor*, scheduled to
run at user login, executes

```powershell
    .\Test-IsOnBattery.ps1 -computer [localhost] -sleep [600]
```

On -computer [default: localhost], check every -sleep [default: 600 seconds]
and send a notification to plug or unplug when outside the recommended power
range.

The assumed location for the files is
`%USERPROFILE%\Documents\Scripts\battery`. Other locations may prevent Task
Scheduler from starting, e.g., `%USERPROFILE\Google Drive\Scripts\battery` fails
to start. The path is hardcoded in *Battery Monitor.xml*: twice on line 46.

## Dependencies

* [BurntToast](https://www.powershellgallery.com/packages/BurntToast)
  *ScheduleTask.ps1* will install under the `CurrentUser` if not already. It will
  also set PSGallery as a Trusted `PSRepository`.

## Credit

* [petri building battery manager powershell](https://www.petri.com/building-battery-manager-powershell) demonstrated how to access the battery status using `Get-WmiObject`.
* [fossbytes should i keep laptop battery plugged all time harmful](https://fossbytes.com/should-i-keep-laptop-battery-plugged-all-time-harmful/) provides the rationale for the charging range.

## Change Log

### v0.1.6

* Change to powershell -ExecutionPolicy Bypass. Set-ExecutionPolicy does not need to be changed to Bypass for script to run as this can be set by powershell Param.
* Combine Get-WmiObject calls into $BatteryStatus.
* Change sleep from 600 seconds to Param $sleep with default a 600 seconds.

### v0.1.5

* The Task Scheduler XML needs to contain the current computer name and user
  name. Replace Task.Triggers.LogonTrigger.UserID with values from the
  environment variables.

### v0.1.4

* Add MIT license. Same as dependency.
* Fix README to align with fully charged notifications.

### v0.1.3

* Refactor to reduce number of -NOT statements and delete unused statements.

### v0.1.2

* Bug fix to use charging status instead of > 99% to suppress unplug warning.
* Bug fix to formatting of Task Scheduler description.

### v0.1.1

* Add specific exception and catch logic to ScheduleTask.ps1.
* Add feature to prompt user to delete old version when running ScheduleTask.ps1.
