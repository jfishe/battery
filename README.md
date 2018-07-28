# Generate Toast notifications when battery is outside 50 - 75%

The [BurntToast](https://www.Powershellgallery.com/packages/BurntToast)
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

## Powershell Repository

Clone the git repository into a convenient location and change to the cloned directory.

```powershell
git clone https://github.com/jfishe/battery.git # Add path to battery destination if desired.
cd battery # The following commands assume this current working directory.
```

Use `git pull` to update to a newer version when available or clone the
repository again.

Setup a local NuGet repository on a shared location. Google Drive is used as an
example. You can use any valid name for the `Powershell` directory and
`LocalRepo1`. `LocalRepo1` should be trusted so you can Install-Module from
there.

```powershell
mkdir "$env:USERPROFILE\Google Drive\Powershell"
Register-PSRepository -Name LocalRepo1 -SourceLocation "$env:USERPROFILE\Google Drive\Powershell" -InstallationPolicy Trusted
```

[Publish-Module](http://go.microsoft.com/fwlink/?LinkId=821666) cloned
repository to the shared location. Repeat this step after `git pull` on the
battery.git repository.

```powershell
Publish-Module -Path .\ScheduleTask_Test-IsOnBattery -Repository "LocalRepo1"
```

### Test-ModuleManifest

`Test-ModuleManifest` checks the `.psd1` file and reports results similar to
the following. This step is not necessary but useful for me when I make
changes.

```powershell
Test-ModuleManifest .\ScheduleTask_Test-IsOnBattery.psd1 | Format-List -Force


Name              : ScheduleTask_Test-IsOnBattery
Path              : C:\Users\fishe\Documents\Scripts\battery\ScheduleTask_Test-IsOnBattery\ScheduleTask
                    _Test-IsOnBattery.psd1
Description       : Create/manage Task Scheduler entry to monitor battery charging and maximize
                    battery lifetime.
ModuleType        : Script
Version           : 0.2.2
NestedModules     : {}
ExportedFunctions : {New-BurntToastNotification, Register-BatteryMonitor, Unregister-BatteryMonitor,
                    Test-IsOnBattery}
ExportedCmdlets   :
ExportedVariables :
ExportedAliases   :
```

## Installation


Install the module in the `CurrentUser` location in `$env:PSModulePath` and make help available:

* Install BurntToast, if not already. Instructions are available at
  [BurntToast](https://github.com/Windos/BurntToast).
* Then install `ScheduleTask_Test-IsOnBattery`:

```powershell
Install-Module -Name ScheduleTask_Test-IsOnBattery -Repository LocalRepo1 -Scope CurrentUser
```
## Usage

To make the help available and add `Battery Monitor` to the `Task Scheduler` app:

```powershell
Import-Module ScheduleTask_Test-IsOnBattery
Register-BatteryMonitor
```
Refer to help for additional details:

```powershell
Get-Help Register-BatteryMonitor
Get-Help Test-IsOnBattery
Get-Help Unregister-BatteryMonitor
```

## Dependencies

* [BurntToast](https://www.Powershellgallery.com/packages/BurntToast)
  should be installed under the `CurrentUser` if not already. PSGallery may need to be added as a Trusted `PSRepository`.
* [ScheduledTasks](https://docs.microsoft.com/en-us/powershell/module/scheduledtasks/?view=win10-ps) should be installed by default under Windows 10. It provides the cmdlets used to interact with Task Scheduler.

### Development

* [platyPS](https://github.com/Powershell/platyPS) for conversion of Markdown
  help files to XML MAML format.
* https://github.com/PowerShell/PowerShell-Docs/blob/live/appveyor.ps1
* [Setting up an Internal PowerShellGet Repository](https://blogs.msdn.microsoft.com/powershell/2014/05/20/setting-up-an-internal-powershellget-repository/) provides instructions for setting up NuGet creating a local repository such as LocalRepo1.

## Credit

* [petri building battery manager Powershell](https://www.petri.com/building-battery-manager-Powershell) demonstrated how to access the battery status using `Get-WmiObject`.
* [fossbytes should i keep laptop battery plugged all time harmful](https://fossbytes.com/should-i-keep-laptop-battery-plugged-all-time-harmful/) provides the rationale for the charging range.
* [platyPS](https://github.com/Powershell/platyPS) for conversion of Markdown help files to XML MAML format.

## Change Log

### v0.3.0

Refactor to use ScheduledTasks module to generate Task Scheduler entry. Remove
XML string that was exported from Task Schedule.

Remove BurntToast from exported functions as it is available in the environment by default.

Add Write-Verbose statement to echo the current state.

Automate publish-module with PSDeploy.

TODO: Replace WMI with CIM call.

### v0.2.3

* Use platyPS to generate XML MAML format help files. Markdown version in ./docs.
* Add module installation instructions to README.

### v0.2.0
* Convert scripts into functions and combine in a module.
* Create script module manifest.

### v0.1.6

* Change to Powershell -ExecutionPolicy Bypass. Set-ExecutionPolicy does not need to be changed to Bypass for script to run as this can be set by Powershell Param.
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
