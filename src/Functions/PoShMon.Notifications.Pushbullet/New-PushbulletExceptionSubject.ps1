Function New-PushbulletExceptionSubject
{
    [CmdletBinding()]
    Param(
        [hashtable]$PoShMonConfiguration,
        [ValidateSet("Monitoring", "Repairing")]
        [string]$Action = "Monitoring" 
    )

    return "[PoshMon $($PoShMonConfiguration.General.EnvironmentName) $Action]`r`n"
}