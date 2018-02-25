Param($computer = "localhost")

# add the required .NET assembly
Add-Type -AssemblyName System.Windows.Forms

Function Test-IsOnBattery{
    Param([string]$computer)
    [BOOL](Get-WmiObject -Class BatteryStatus -Namespace root\wmi -ComputerName $computer).PowerOnLine
} # end function test-IsOnBattery

$FullChargedCapacity = (Get-WmiObject -Class BatteryFullChargedCapacity -Namespace root\wmi -ComputerName $computer).FullChargedCapacity

while ($true) {
    $RemainingCapacity = (Get-WmiObject -Class BatteryStatus -Namespace root\wmi -ComputerName $computer).RemainingCapacity
    $iPercent = [int](($RemainingCapacity / $FullChargedCapacity * 100 ) % 100)

    If (Test-IsOnBattery($computer) -AND ($iPercent -gt 75)) {
        [System.Windows.Forms.MessageBox]::Show('Battery is fully charged') }
    ElseIf (-NOT (Test-IsOnBattery($computer)) -AND ($iPercent -lt 50)) {
        [System.Windows.Forms.MessageBox]::Show('Please charge Battery') }
    # Else {
    #     [System.Windows.Forms.MessageBox]::Show('Battery is OK')
    # }
    Start-Sleep -Seconds 600
}
