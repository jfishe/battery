Param($computer = "localhost")

# Add New-BurntToastNotification
Import-Module BurntToast

Function Test-PowerOnLine{
    Param([string]$computer)
    [BOOL](Get-WmiObject -Class BatteryStatus -Namespace root\wmi -ComputerName $computer).PowerOnLine
} # end function test-PowerOnLine

$FullChargedCapacity = (Get-WmiObject -Class BatteryFullChargedCapacity -Namespace root\wmi -ComputerName $computer).FullChargedCapacity

while ($true) {
    $IsPowerOnLine = Test-PowerOnLine($computer)

    $RemainingCapacity = (Get-WmiObject -Class BatteryStatus -Namespace root\wmi -ComputerName $computer).RemainingCapacity
    $iPercent = [int](($RemainingCapacity / $FullChargedCapacity * 100 ) % 100)
    $IsCharging = [BOOL](Get-WmiObject -Class BatteryStatus -Namespace root\wmi -ComputerName $computer).Charging

    If ( (-NOT ($IsPowerOnLine)) -AND ($iPercent -lt 50)) {
        New-BurntToastNotification -Text "Please Plug In!", 'Batter Charge < 50%!' -UniqueIdentifier 'Test-IsPowerOnLine'
    } ElseIf ((-NOT ($IsCharging)) -AND ($IsPowerOnLine)) {
        Continue
    } ElseIf (($iPercent -gt 75) -AND ($IsPowerOnLine)) {
        New-BurntToastNotification -Text "Please Unplug!", 'Batter Charge > 75%!' -UniqueIdentifier 'Test-IsPowerOnLine'
    }

    Start-Sleep -Seconds 600
}
