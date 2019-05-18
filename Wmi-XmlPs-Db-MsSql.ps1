[string] $COMP_NAME             = $env:COMPUTERNAME
[string] $DB_PROVIDER_MSSQL      = "System.Data.SqlClient"
[string] $DB_SERVER_NAME_MSSQL   = "YOU_SERVER"
[string] $DB_NAME_MSSQL          = "Computers"


class clsWmiPs
{
    [string] $strComputerName

    clsWmiPs()
    {
        $this.strComputerName = "."
    }

    clsWmiPs([string] $sComputerName)
    {
        $this.strComputerName = $sComputerName
    }

    [xml] GetIpXml()
    {
        return Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true -ComputerName $this.strComputerName | Select-Object PSComputerName,DNSHostName,Description,Caption,DHCPEnabled,IPAddress,IPSubnet,MACAddress,DNSServerSearchOrder,DNSDomainSuffixSearchOrder,DefaultIPGateway | ConvertTo-XML -NoTypeInformation
    }

    [xml] GetCpuXml()
    {
        return Get-WmiObject -Class Win32_Processor -ComputerName $this.strComputerName | Select-Object  PSComputerName,Manufacturer,Name,DeviceID,NumberOfCores,NumberOfLogicalProcessors,CurrentClockSpeed,L2CacheSize,L3CacheSize | ConvertTo-XML -NoTypeInformation  
    }

    [xml] GetBiosXml()
    {
        return Get-WmiObject -Class Win32_BIOS -ComputerName $this.strComputerName  | Select-Object PSComputerName,Name,SerialNumber,Version,Description,SMBIOSBIOSVersion,SMBIOSMajorVersion | ConvertTo-XML -NoTypeInformation  
    }

    [xml] GetVideoXml()
    {
        return Get-WmiObject -Class Win32_VideoController -ComputerName $this.strComputerName  | Select-Object PSComputerName,AdapterCompatibility,AdapterDACType,AdapterRAM,Description,DriverDate,DriverVersion,Name,VideoModeDescription,VideoProcessor |  ConvertTo-XML -NoTypeInformation  
    }
   
    [xml] GetHddXml()
    {
        return Get-WmiObject -Class Win32_DiskDrive -ComputerName $this.strComputerName  | Select-Object PSComputerName,Description,FirmwareRevision,Model,Manufacturer,Partitions,SerialNumber,Size,Status,SCSIBus,SCSILogicalUnit,SCSIPort,SCSITargetId,InterfaceType | ConvertTo-XML -NoTypeInformation 
    }

    [xml] GetRamXml()
    {
        return Get-WmiObject -Class Win32_PhysicalMemory -ComputerName $this.strComputerName  | Select-Object PSComputerName,BankLabel,Capacity,DeviceLocator,Model,Manufacturer,FormFactor,PartNumber,SerialNumber,Speed | ConvertTo-XML -NoTypeInformation
    }

    [xml] GetUsersXml()
    {
        $LoggedOnUser =  Get-CimInstance -ComputerName $this.strComputerName -ClassName Win32_LoggedOnUser 
        return ( Get-CimInstance  -ComputerName $this.strComputerName -ClassName Win32_LogonSession | ? { $_.LogonType -eq 2 -or  $_.LogonType -eq 10} | %{
                  $id = $_.LogonId
                  $usr = $LoggedOnUser | ? { $_.Dependent.LogonId -eq $id}
                            if($usr -ne $null) 
                            {
                                New-Object -TypeName psobject -Property @{
                                    PSComputerName = $this.strComputerName
                                    StartTime =  $_.StartTime.ToString()
                                    DomainName = $usr.Antecedent.Domain
                                    UserName = $usr.Antecedent.Name 
                                }
                            }

                  }|   ConvertTo-XML -NoTypeInformation)
    }

    [string] GetXmlString( [xml] $xml)
    {
         return $xml.OuterXml.Replace('encoding="utf-8"','')
    }


}


class clsDb
{
    [System.Data.Common.DbProviderFactory]          $factory
    [System.Data.Common.DbConnection]               $conn
    [System.Data.Common.DbConnectionStringBuilder]  $csb
    [string] $strProviderName
    [string] $strServer
    [string] $strDatabase
    [string] $strUserID
    [string] $strPass


    clsDb()
    {
        $this.factory = $null
        $this.conn    = $null
        $this.csb     = $null
        $this.strProviderName = ""
        $this.strServer       = ""
        $this.strDatabase     = ""
    }

    clsDb([string] $ProviderName,[string] $Server,[string] $Database)
    {
        $this.factory = $null
        $this.conn    = $null
        $this.csb     = $null
        $this.strProviderName = $ProviderName
        $this.strServer       = $Server
        $this.strDatabase     = $Database
        $this.conn =  $this.CreateConnection($this.strServer,$this.strDatabase)
    }

    clsDb([string]  $UserID, [string] $Pass,[string] $ProviderName,[string] $Server,[string] $Database)
    {
        $this.factory = $null
        $this.conn    = $null
        $this.csb     = $null
        $this.strProviderName = $ProviderName
        $this.strServer       = $Server
        $this.strDatabase     = $Database
        $this.strUserID = $UserID
        $this.strPass = $Pass
        $this.conn =  $this.CreateConnection( $this.strUserID,$this.strPass,$this.strServer,$this.strDatabase)
    }

    [System.Data.Common.DbProviderFactory] GetFactory()
    {

        if($this.factory -eq $null)
        {
            try 
            {
                $this.factory = [System.Data.Common.DbProviderFactories]::GetFactory($this.strProviderName)
                Write-Host "clsDb:GFactory = " $this.factory.GetType()
                return $this.factory
            } 
            catch [System.ArgumentException] 
            {
                if($this.strProviderName -eq "MySql.Data.MySqlClient")
                {
                    $this.factory = new-object "MySql.Data.MySqlClient.MySqlClientFactory"
                    Write-Host "clsDb:GFactory = " $this.factory.GetType()
                    return $this.factory
                }
                else
                {
                    Write-Host "clsDb:GFactory: Null"
                    return $null
                }
            }
        }
        else
        {
            return $this.factory
        }
        
    }

    [System.Data.Common.DbConnection] GetConnection()
    {
        return $this.conn
    }

    [System.Data.Common.DbConnection] CreateConnection([string] $UserID, [string] $Password,[string] $Server,[string]  $Database)
    {
            try 
            {
                $this.csb = $this.GetFactory().CreateConnectionStringBuilder()
                $this.csb.Add("User ID", $UserID)
                $this.csb.Add("Password", $Password)
                $this.csb.Add("Server", $Server)
                $this.csb.Add("Database", $Database)
                if($this.strProviderName -eq "MySql.Data.MySqlClient")
                {
                     $this.csb.Add("charset", "utf8")
                }
                Write-Host "clsDb:CreateConnection: " $this.csb.ConnectionString

                $this.conn =  $this.GetFactory().CreateConnection()
                $this.conn.ConnectionString = $this.csb.ConnectionString
                return $this.conn
            }
            catch [System.ArgumentException] 
            {
                return $null
            }
    }

    [System.Data.Common.DbConnection] CreateConnection([string] $Server,[string]  $Database)
    {
            try 
            {
                $this.csb = $this.GetFactory().CreateConnectionStringBuilder()
                $this.csb.Add("Server", $Server)
                $this.csb.Add("Database", $Database)
                $this.csb.Add("Integrated Security", $true)
                
                if($this.strProviderName -eq "MySql.Data.MySqlClient")
                {
                     $this.csb.Add("charset", "utf8")
                }
                Write-Host "clsDb:CreateConnection: " $this.csb.ConnectionString

                $this.conn =  $this.GetFactory().CreateConnection()
                $this.conn.ConnectionString = $this.csb.ConnectionString
                return $this.conn
            }
            catch [System.ArgumentException] 
            {
                return $null
            }
    }

    [System.Data.Common.DbCommand] CreateCommandSp([string] $CommandText,[string]  $ParameterName)
    {
            try 
            {
                [System.Data.Common.DbCommand] $cmd = $this.GetFactory().CreateCommand()
                $cmd.Connection = $this.GetConnection()
                $cmd.CommandType = [System.Data.CommandType]::StoredProcedure;
                $cmd.CommandText = $CommandText
                $cmd.Parameters.Add($this.CreateParameter($ParameterName,[System.Data.DbType]::String))
                return  $cmd
            }
            catch [System.ArgumentException] 
            {
                return $null
            }
    }

    [System.Data.Common.DbCommand] CreateCommandSp([string] $CommandText,[string]  $ParameterName, [string] $val)
    {
            try 
            {
                [System.Data.Common.DbCommand] $cmd = $this.GetFactory().CreateCommand()
                $cmd.Connection = $this.GetConnection()
                $cmd.CommandType = [System.Data.CommandType]::StoredProcedure;
                $cmd.CommandText = $CommandText
                $cmd.Parameters.Add($this.CreateParameter($ParameterName,[System.Data.DbType]::String,$val))
                return  $cmd
            }
            catch [System.ArgumentException] 
            {
                return $null
            }
    }

    [System.Data.Common.DbParameter] CreateParameter([string] $ParameterName, [System.Data.DbType] $DbType)
    {
            try 
            {
                [System.Data.Common.DbParameter] $param =  $this.GetFactory().CreateParameter()
                $param.ParameterName = $ParameterName
                $param.DbType = $DbType
                return $param
            }
            catch [System.ArgumentException] 
            {
                return $null
            }
               
    }

    [System.Data.Common.DbParameter] CreateParameter([string] $ParameterName, [string] $SourceColumn, [System.Data.DbType] $DbType)
    {
            try 
            {
                [System.Data.Common.DbParameter] $param =  $this.GetFactory().CreateParameter()
                $param.ParameterName = $ParameterName
                $param.SourceColumn = $SourceColumn
                $param.DbType = $DbType
                return $param
            }
            catch [System.ArgumentException] 
            {
                return $null
            }
               
    }

    [System.Data.Common.DbParameter] CreateParameter([string] $ParameterName, [System.Data.DbType] $DbType, [string] $val)
    {
            try 
            {
                [System.Data.Common.DbParameter] $param =  $this.GetFactory().CreateParameter()
                $param.ParameterName = $ParameterName
                $param.DbType = $DbType
                $param.Value = $val
                return $param
            }
            catch [System.ArgumentException] 
            {
                return $null
            }
               
    }

    [System.Data.Common.DbDataAdapter] InsertDataTable([string] $sp,[System.Data.DataTable] $tab)
    {
         try 
            {
                [System.Data.Common.DbDataAdapter] $adapter =  $this.GetFactory().CreateDataAdapter()


                $adapter.InsertCommand = $this.conn.CreateCommand()
                $adapter.InsertCommand.CommandType = [System.Data.CommandType]::StoredProcedure;
                $adapter.InsertCommand.CommandText = $sp
                foreach($col in $tab.Columns )
                {
                    $adapter.InsertCommand.Parameters.Add($this.CreateParameter("@p" + $col.ToString(),$col.ToString(),[System.Data.DbType]::String))
                }
                $adapter.Update($tab)
                return $adapter
            }
            catch [System.ArgumentException] 
            {
                return $null
            }
    }


    [bool] ExecuteCmd($cmd)
    {
        if ($cmd -ne $null) 
        {
            Write-Host $cmd.CommandText
            ForEach ($param in $cmd.Parameters) 
            {
                 Write-Host "ParameterName = " $param.ParameterName
                 Write-Host "ParameterValue = " $param.Value
            }
            
            if($cmd.Connection.State -eq [System.Data.ConnectionState]::Closed)
            {
                $cmd.Connection.Open()
                Write-Host "EXEC" $cmd.ExecuteNonQuery()
                return $true
            }
            else
            {
                $cmd.ExecuteNonQuery()
                return $true
            }
        }
        else
        {
            Write-Host "cmd is null!"
            return $false
        }
  
	}
}



[clsWmiPs] $wmi = [clsWmiPs]::new($COMP_NAME)
<#$wmi.GetXmlString( $wmi.GetBiosXml())
$wmi.GetXmlString( $wmi.GetCpuXml())
$wmi.GetXmlString( $wmi.GetHddXml())
$wmi.GetXmlString( $wmi.GetIpXml())
$wmi.GetXmlString( $wmi.GetRamXml())
$wmi.GetXmlString( $wmi.GetUsersXml())
$wmi.GetXmlString( $wmi.GetVideoXml())
#>

[clsDb] $mssql = [clsDb]::new($DB_PROVIDER_MSSQL,$DB_SERVER_NAME_MSSQL,$DB_NAME_MSSQL )
$mssql.ExecuteCmd($mssql.CreateCommandSp("InsertPsBiosLogXml",  "@xmlText",$wmi.GetXmlString( $wmi.GetBiosXml())))
$mssql.ExecuteCmd($mssql.CreateCommandSp("InsertPsCpuLogXml",   "@xmlText",$wmi.GetXmlString( $wmi.GetCpuXml())))
$mssql.ExecuteCmd($mssql.CreateCommandSp("InsertPsHddLogXml",   "@xmlText",$wmi.GetXmlString( $wmi.GetHddXml())))
$mssql.ExecuteCmd($mssql.CreateCommandSp("InsertPsIpAddrLogXml","@xmlText",$wmi.GetXmlString( $wmi.GetIpXml())))
$mssql.ExecuteCmd($mssql.CreateCommandSp("InsertPsRamLogXml",   "@xmlText",$wmi.GetXmlString( $wmi.GetRamXml())))
$mssql.ExecuteCmd($mssql.CreateCommandSp("InsertPsUsersLogXml", "@xmlText",$wmi.GetXmlString( $wmi.GetUsersXml())))
$mssql.ExecuteCmd($mssql.CreateCommandSp("InsertPsVideoLogXml", "@xmlText",$wmi.GetXmlString( $wmi.GetVideoXml())))
