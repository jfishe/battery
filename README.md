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

If the laptop is left plugged in and exceeds 99%, toast notifications will stop
since always plugged in is a good condition. Between 75 and 100%, toast
notifications will repeat every 10 minutes.

## Installation

[ScheduleTask.ps1](file://./ScheduleTask.ps1) creates a Task Scheduler entry
for the current user, called *Battery Monitor*. *Battery Monitor*, scheduled to
run at user login, executes
*Test-IsOnBattery.ps1* which checks every 5 minutes and sends a notification to
plug or unplug when outside the recommended power range.

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
