---
Module Name: ScheduleTask_Test-IsOnBattery
Module Guid: dcd76b0f-5610-4169-9bb6-ab38db67e848
Download Help Link:
Help Version: 0.2.0.0
Locale: en-US
---

# ScheduleTask_Test-IsOnBattery Module
## Description
Create/manage Task Scheduler entry to monitor battery charging and maximize battery lifetime.

## ScheduleTask_Test-IsOnBattery Cmdlets
### [Register-BatteryMonitor](Register-BatteryMonitor.md)
Register-BatteryMonitor Add/replace Task Scheduler App Libary entry for Battery Monitor. Battery Monitor will run Test-IsOnBattery at user login.

### [Test-IsOnBattery](Test-IsOnBattery.md)
Test-IsOnBattery sends a Toast notification when battery charging/discharging is outside the optimum range for battery lifetime.

### [Unregister-BatteryMonitor](Unregister-BatteryMonitor.md)
Unregister-BatteryMonitor remove Task Scheduler App Libary entry for Battery Monitor.

