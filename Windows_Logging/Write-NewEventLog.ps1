﻿function Write-EventLog
{
    [cmdletbinding()]
    param(  
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [String]$LogName,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [String]$Source,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [int]$EventId,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Diagnostics.EventLogEntryType]$EntryType,
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [String]$Message,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Int16]$Category,
        [Parameter(ValueFromPipelineByPropertyName)]
        [String]$ComputerName,
        [Parameter(ValueFromPipelineByPropertyName)]
    [Byte[]]$RawData,   
        [Switch]$Force 
    )

    begin
    {
        if($Force)
        {
            if (-not ([Diagnostics.EventLog]::Exists($LogName) -and [Diagnostics.EventLog]::SourceExists($Source) )) 
            {
                New-EventLog -LogName $LogName -Source $Source 
            }
        }  
        
              $params = @{
            #put mandatory params here directly
            LogName = $LogName
            Source = $Source
            EventId = $EventId
        }
    }
    process 
    {

        if($EntryType)
        { $params.Add('EntryType', $EntryType) }
        if($Message)
        { $params.Add('Message', $Message) }
        if($Category)
        {$params.Add('Category', $Category) }
        if($ComputerName)
        { $params.Add('ComputerName', $ComputerName) }
        if($null -ne $RawData)
        { $params.Add('RawData', $RawData) }

        #since your parameters are named the same way as Write-EventLog parameters, and you use cmdlet binding
        #you might get away with just specifying @PSBoundParameters
        #Write-EventLog @params 
    }
}

Write-EventLog -LogName 'PS Test Log' -Source 'My Script' -EntryType Information -EventID 100 -Message 'This is a test message.'
