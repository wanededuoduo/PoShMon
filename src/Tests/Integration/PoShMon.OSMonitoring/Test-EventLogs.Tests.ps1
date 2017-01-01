$rootPath = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -ChildPath ('..\..\') -Resolve
$sutFileName = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests", "")
$sutFilePath = Join-Path $rootPath -ChildPath "Functions\PoShMon.OSMonitoring\$sutFileName" 
. $sutFilePath
$depFilePath = Join-Path $rootPath -ChildPath "Functions\PoShMon.Shared\Format-Gigs.ps1"
. $depFilePath
$depFilePath = Join-Path $rootPath -ChildPath "Functions\PoShMon.OSMonitoring\Get-GroupedEventLogItemsBySeverity.ps1"
. $depFilePath

class EventLogItemMock {
    [int]$EventCode
    [string]$SourceName
    [string]$User
    [string]$TimeGenerated
    [string]$Message

    EventLogItemMock ([int]$NewEventCode, [String]$NewSourceName, [String]$NewUser, [String]$NewTimeGenerated, [String]$NewMessage) {
        $this.EventCode = $NewEventCode;
        $this.SourceName = $NewSourceName;
        $this.User = $NewUser;
        $this.TimeGenerated = $NewTimeGenerated;
        $this.Message = $NewMessage;
    }

    [string] ConvertToDateTime([string]$something) {
        return (Get-Date).ToString()
    }
}
<#
Describe "Test-EventLogs" {
    It "Should return a matching output structure" {
    
        Mock -CommandName Get-WmiObject -MockWith {
            $eventsCollection = @()

            $eventsCollection += [EventLogItemMock]::new(123, "Test App", "domain\user1", "123", "Sample Message")
            return $eventsCollection
        }

        $actual = Test-EventLogs -ServerNames 'Server1'

        $actual.Keys.Count | Should Be 5
        $actual.ContainsKey("NoIssuesFound") | Should Be $true
        $actual.ContainsKey("OutputHeaders") | Should Be $true
        $actual.ContainsKey("OutputValues") | Should Be $true
        $actual.ContainsKey("SectionHeader") | Should Be $true
        $actual.ContainsKey("ElapsedTime") | Should Be $true
        $headers = $actual.OutputHeaders
        $headers.Keys.Count | Should Be 6
        $headers.ContainsKey("EventID") | Should Be $true
        $headers.ContainsKey("InstanceCount") | Should Be $true
        $headers.ContainsKey("Source") | Should Be $true
        $headers.ContainsKey("User") | Should Be $true
        $headers.ContainsKey("Timestamp") | Should Be $true
        $headers.ContainsKey("Message") | Should Be $true
        $valuesGroup1 = $actual.OutputValues[0]
        $valuesGroup1.Keys.Count | Should Be 2
        $values1 = $valuesGroup1.GroupOutputValues
        $values1.Keys.Count | Should Be 6
        $values1.ContainsKey("EventID") | Should Be $true
        $values1.ContainsKey("InstanceCount") | Should Be $true
        $values1.ContainsKey("Source") | Should Be $true
        $values1.ContainsKey("User") | Should Be $true
        $values1.ContainsKey("Timestamp") | Should Be $true
        $values1.ContainsKey("Message") | Should Be $true
    }

    It "Should alert on items found" {
        
        Mock -CommandName Get-WmiObject -MockWith {
            $eventsCollection = @()

            $eventsCollection += [EventLogItemMock]::new(123, "Test App", "domain\user1", "123", "Sample Message")
            return $eventsCollection
        }

        $actual = Test-EventLogs -ServerNames 'Server1'
        
        $actual.NoIssuesFound | Should Be $false
    }
    It "Should group per server" {
        
        $expected = @{
            "NoIssuesFound" = $true;
            "outputHeaders" = @{ 'EventID' = 'Event ID'; 'InstanceCount' = 'Count'; 'Source' = 'Source'; 'User' = 'User'; 'Timestamp' = 'Timestamp'; 'Message' ='Message' };
            "OutputValues" = @()
            }

        $expected["OutputValues"] += @{
                        'DriveLetter' = 'C:';
                        'TotalSpace' = 243631;
                        'FreeSpace' = 58313;
                        'Highlight' = ''
                    }

        Mock -CommandName Get-WmiObject -MockWith {
            $eventsCollection = @()

            $eventsCollection += [EventLogItemMock]::new(123, "Test App", "domain\user1", "123", "Sample Message")
            $eventsCollection += [EventLogItemMock]::new(123, "Test App", "domain\user1", "123", "Sample Message")
            $eventsCollection += [EventLogItemMock]::new(123, "Test App", "domain\user1", "123", "Another Sample Message")
            $eventsCollection += [EventLogItemMock]::new(456, "Test App", "domain\user1", "123", "Different Event Code")

            return $eventsCollection
        }

        $actual = Test-EventLogs -ServerNames 'Server1','Server2'
        
        $actual.NoIssuesFound | Should Be $false

        $actual.OutputValues.Count  | Should Be 2
        $actual.OutputValues[0].GroupName  | Should Be 'Server1'
        $actual.OutputValues[1].GroupName  | Should Be 'Server2'
    }
    It "Should group on EventID and Message" {
        
        $expected = @{
            "NoIssuesFound" = $true;
            "outputHeaders" = @{ 'EventID' = 'Event ID'; 'InstanceCount' = 'Count'; 'Source' = 'Source'; 'User' = 'User'; 'Timestamp' = 'Timestamp'; 'Message' ='Message' };
            "OutputValues" = @()
            }

        $expected["OutputValues"] += @{
                        'DriveLetter' = 'C:';
                        'TotalSpace' = 243631;
                        'FreeSpace' = 58313;
                        'Highlight' = ''
                    }

        Mock -CommandName Get-WmiObject -MockWith {
            $eventsCollection = @()

            $eventsCollection += [EventLogItemMock]::new(123, "Test App", "domain\user1", "123", "Sample Message")
            $eventsCollection += [EventLogItemMock]::new(123, "Test App", "domain\user1", "123", "Sample Message")
            $eventsCollection += [EventLogItemMock]::new(123, "Test App", "domain\user1", "123", "Another Sample Message")
            $eventsCollection += [EventLogItemMock]::new(456, "Test App", "domain\user1", "123", "Different Event Code")

            return $eventsCollection
        }

        $actual = Test-EventLogs -ServerNames localhost
        
        $actual.NoIssuesFound | Should Be $false

        $actual.OutputValues[0].GroupOutputValues.Count | Should Be 3
        $actual.OutputValues[0].GroupOutputValues[0].InstanceCount | Should Be 2
        $actual.OutputValues[0].GroupOutputValues[1].InstanceCount | Should Be 1
        $actual.OutputValues[0].GroupOutputValues[2].InstanceCount | Should Be 1
    }
}

#>