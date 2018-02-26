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
        New-BurntToastNotification -Text "Please Plug In!", 'Batter Charge < 50%!' -SnoozeAndDismiss
        # [System.Windows.Forms.MessageBox]::Show('Please charge Battery')
    } ElseIf (($iPercent -gt 75) -AND (-NOT ($IsOnBattery))) {
        New-BurntToastNotification -Text "Please Unplug!", 'Batter Charge > 75%!' -SnoozeAndDismiss
        # [System.Windows.Forms.MessageBox]::Show('Unplug. Battery is fully charged')
    # } Else {
      #     [System.Windows.Forms.MessageBox]::Show('Battery is OK')
    }

    Start-Sleep -Seconds 600
}
