Param($computer = "localhost")

# add the required .NET assembly
Add-Type -AssemblyName System.Windows.Forms

# Add New-BurntToastNotification
Import-Module BurntToast

Function Test-PowerOnLine{
    Param([string]$computer)
    [BOOL](Get-WmiObject -Class BatteryStatus -Namespace root\wmi -ComputerName $computer).PowerOnLine
} # end function test-PowerOnLine

$FullChargedCapacity = (Get-WmiObject -Class BatteryFullChargedCapacity -Namespace root\wmi -ComputerName $computer).FullChargedCapacity

while ($true) {
    $IsOnBattery = -NOT (Test-PowerOnLine($computer))

    $RemainingCapacity = (Get-WmiObject -Class BatteryStatus -Namespace root\wmi -ComputerName $computer).RemainingCapacity
    $iPercent = [int](($RemainingCapacity / $FullChargedCapacity * 100 ) % 100)

    If (($IsOnBattery) -AND ($iPercent -lt 50)) {
        New-BurntToastNotification -Text "Please Plug In!", 'Batter Charge < 50%!' -UniqueIdentifier 'Test-IsOnBattery'
    } ElseIf (($iPercent -gt 99) -AND (-NOT ($IsOnBattery))) {
        Continue
    } ElseIf (($iPercent -gt 75) -AND (-NOT ($IsOnBattery))) {
        New-BurntToastNotification -Text "Please Unplug!", 'Batter Charge > 75%!' -UniqueIdentifier 'Test-IsOnBattery'
    }

    Start-Sleep -Seconds 600
}
