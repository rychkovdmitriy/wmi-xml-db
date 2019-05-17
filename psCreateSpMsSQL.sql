USE [Computers]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('dbo.InsertPsBiosLogXml', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[InsertPsBiosLogXml]
GO

CREATE PROCEDURE [dbo].[InsertPsBiosLogXml]
@xmlText nvarchar(max)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @dateUpdate DateTime;
	SET @dateUpdate = GetDate();
 	DECLARE @XmlDocument xml;
  	SET @XmlDocument = TRY_CONVERT(xml,@xmlText);

	MERGE  [psBiosLog] AS tabBios  
		 USING(
			 SELECT
				  tab.col.value('string((Property[@Name="PSComputerName"])[1])','NVARCHAR(250)')	    AS cPSComputerName,
				  tab.col.value('string((Property[@Name="Name"]/text())[1])','NVARCHAR(250)')           AS cName,
				  tab.col.value('string((Property[@Name="SerialNumber"])[1])','NVARCHAR(250)')          AS cSerialNumber,
				  tab.col.value('string((Property[@Name="Version"])[1])','NVARCHAR(250)')               AS cVersion,
				  tab.col.value('string((Property[@Name="Description"])[1])','NVARCHAR(250)')           AS cDescription,
				  tab.col.value('string((Property[@Name="SMBIOSBIOSVersion"])[1])','NVARCHAR(250)')     AS cSMBIOSBIOSVersion,
				  tab.col.value('string((Property[@Name="SMBIOSMajorVersion"])[1])','NVARCHAR(250)')    AS cSMBIOSMajorVersion
			  FROM @XmlDocument.nodes('/Objects/Object')AS  tab(col) 
			) AS tabXmlBios 
	ON (tabBios.[PSComputerName] = tabXmlBios.cPSComputerName and 
		    tabBios.[Name] = tabXmlBios.cName and 
			tabBios.[SerialNumber] = tabXmlBios.cSerialNumber and 
			tabBios.[Version] = tabXmlBios.cVersion	and 
			tabBios.[Description] = tabXmlBios.cDescription and
			tabBios.[SMBIOSBIOSVersion] = tabXmlBios.cSMBIOSBIOSVersion and  
			tabBios.[SMBIOSMajorVersion] = tabXmlBios.cSMBIOSMajorVersion)
	WHEN NOT MATCHED BY TARGET THEN  INSERT ([PSComputerName],[Name],[SerialNumber],[Version],[Description],[SMBIOSBIOSVersion],[SMBIOSMajorVersion])
									 VALUES (cPSComputerName, cName, cSerialNumber, cVersion, cDescription, cSMBIOSBIOSVersion, cSMBIOSMajorVersion)
	WHEN MATCHED  THEN UPDATE SET DateUpdate = GetDate();
END
GO

GRANT EXECUTE ON OBJECT::[Computers].[dbo].[InsertPsBiosLogXml]  
    TO [YOU_DOMAIN\Domain Computers];  


IF OBJECT_ID('dbo.InsertPsCpuLogXml', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[InsertPsCpuLogXml]
GO

CREATE PROCEDURE [dbo].[InsertPsCpuLogXml]
@xmlText nvarchar(max)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @dateUpdate DateTime;
	SET @dateUpdate = GetDate();
	DECLARE @XmlDocument xml;
	SET @XmlDocument = TRY_CONVERT(xml,@xmlText);

	MERGE  [psCpuLog] AS tabCpu  
		USING(
			SELECT
				tab.col.value('string((Property[@Name="PSComputerName"])[1])','NVARCHAR(250)')			  AS cPSComputerName,
				tab.col.value('string((Property[@Name="Manufacturer"]/text())[1])','NVARCHAR(250)')       AS cManufacturer,
				tab.col.value('string((Property[@Name="Name"])[1])','NVARCHAR(250)')                      AS cName,
				tab.col.value('string((Property[@Name="DeviceID"])[1])','NVARCHAR(250)')                  AS cDeviceID,
				tab.col.value('string((Property[@Name="NumberOfCores"])[1])','NVARCHAR(250)')             AS cNumberOfCores,
				tab.col.value('string((Property[@Name="NumberOfLogicalProcessors"])[1])','NVARCHAR(250)') AS cNumberOfLogicalProcessors,
				tab.col.value('string((Property[@Name="CurrentClockSpeed"])[1])','NVARCHAR(250)')         AS cCurrentClockSpeed,
				tab.col.value('string((Property[@Name="L2CacheSize"])[1])','NVARCHAR(250)')               AS cL2CacheSize,
				tab.col.value('string((Property[@Name="L3CacheSize"])[1])','NVARCHAR(250)')               AS cL3CacheSize

			FROM  @XmlDocument.nodes('/Objects/Object')AS  tab(col) 
			) AS tabXmlCpu 
	ON (tabCpu.[PSComputerName] = tabXmlCpu.cPSComputerName and 
		    tabCpu.[Manufacturer] = tabXmlCpu.cManufacturer and 
			tabCpu.[Name] = tabXmlCpu.cName and 
			tabCpu.[DeviceID] = tabXmlCpu.cDeviceID and 
			tabCpu.[NumberOfCores] = tabXmlCpu.cNumberOfCores and  
			tabCpu.[NumberOfLogicalProcessors] = tabXmlCpu.cNumberOfLogicalProcessors and  
			tabCpu.[CurrentClockSpeed] = tabXmlCpu.cCurrentClockSpeed and 
			tabCpu.[L2CacheSize] = tabXmlCpu.cL2CacheSize and 
			tabCpu.[L3CacheSize] = tabXmlCpu.cL3CacheSize)
	WHEN NOT MATCHED BY TARGET THEN  INSERT ([PSComputerName],[Manufacturer],[Name],[DeviceID],[NumberOfCores],[NumberOfLogicalProcessors],[CurrentClockSpeed],[L2CacheSize],[L3CacheSize])
									 VALUES (cPSComputerName, cManufacturer, cName, cDeviceID, cNumberOfCores, cNumberOfLogicalProcessors, cCurrentClockSpeed, cL2CacheSize, cL3CacheSize)
	WHEN MATCHED  THEN UPDATE SET DateUpdate = GetDate();  
END
GO

GRANT EXECUTE ON OBJECT::[Computers].[dbo].[InsertPsCpuLogXml]  
    TO [YOU_DOMAIN\Domain Computers];  



IF OBJECT_ID('dbo.InsertPsHddLogXml', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[InsertPsHddLogXml]
GO

CREATE PROCEDURE [dbo].[InsertPsHddLogXml]
@xmlText nvarchar(max)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @dateUpdate DateTime;
	SET @dateUpdate = GetDate();
	DECLARE @XmlDocument xml;
	SET @XmlDocument = TRY_CONVERT(xml,@xmlText);

	 MERGE  [psHddLog] AS tabHdd  
		 USING(
	 SELECT
		  tab.col.value('string((Property[@Name="PSComputerName"])[1])','NVARCHAR(250)')	     AS cPSComputerName,
		  tab.col.value('string((Property[@Name="Caption"])[1])','NVARCHAR(250)')				 AS cCaption,
		  tab.col.value('string((Property[@Name="Description"])[1])','NVARCHAR(250)')            AS cDescription,
		  tab.col.value('string((Property[@Name="FirmwareRevision"])[1])','NVARCHAR(250)')       AS cFirmwareRevision,
		  tab.col.value('string((Property[@Name="Model"])[1])','NVARCHAR(250)')                  AS cModel,
		  tab.col.value('string((Property[@Name="Manufacturer"])[1])','NVARCHAR(250)')           AS cManufacturer,
		  tab.col.value('string((Property[@Name="Partitions"])[1])','NVARCHAR(250)')             AS cPartitions,
		  tab.col.value('string((Property[@Name="SerialNumber"])[1])','NVARCHAR(250)')           AS cSerialNumber,
		  tab.col.value('string((Property[@Name="Size"])[1])','NVARCHAR(250)')                   AS cSize,
		  tab.col.value('string((Property[@Name="Status"])[1])','NVARCHAR(250)')                 AS cStatus,
		  tab.col.value('string((Property[@Name="SCSIBus"])[1])','NVARCHAR(250)')                AS cSCSIBus,
		  tab.col.value('string((Property[@Name="SCSILogicalUnit"])[1])','NVARCHAR(250)')        AS cSCSILogicalUnit,
		  tab.col.value('string((Property[@Name="SCSIPort"])[1])','NVARCHAR(250)')        		 AS cSCSIPort,
		  tab.col.value('string((Property[@Name="SCSITargetId"])[1])','NVARCHAR(250)')        	 AS cSCSITargetId,
		  tab.col.value('string((Property[@Name="InterfaceType"])[1])','NVARCHAR(250)')        	 AS cInterfaceType
		  FROM
		  @XmlDocument.nodes('/Objects/Object')AS  tab(col) 
		) AS tabXmlHdd 
		ON (tabHdd.[PSComputerName] = tabXmlHdd.cPSComputerName and 
									  tabHdd.[Caption] = tabXmlHdd.cCaption and 
									  tabHdd.[Description] = tabXmlHdd.cDescription and  
									  tabHdd.[FirmwareRevision] = tabXmlHdd.cFirmwareRevision and 
									  tabHdd.[Model] = tabXmlHdd.cModel and  
									  tabHdd.[Manufacturer] = tabXmlHdd.cManufacturer and 
									  tabHdd.[Partitions] = tabXmlHdd.cPartitions  and 
									  tabHdd.[SerialNumber] = tabXmlHdd.cSerialNumber and 
									  tabHdd.[Size] = tabXmlHdd.cSize and
									  tabHdd.[Status] = tabXmlHdd.cStatus and  
									  tabHdd.[SCSIBus] = tabXmlHdd.cSCSIBus and 
									  tabHdd.[SCSILogicalUnit] = tabXmlHdd.cSCSILogicalUnit and  
									  tabHdd.[SCSIPort] = tabXmlHdd.cSCSIPort and
									  tabHdd.[SCSITargetId] = tabXmlHdd.cSCSITargetId and  
									  tabHdd.[InterfaceType] = tabXmlHdd.cInterfaceType)
		WHEN NOT MATCHED BY TARGET THEN  INSERT ([PSComputerName],[Caption],[Description],[FirmwareRevision],[Model],[Manufacturer],[Partitions],[SerialNumber],[Size],[Status],[SCSIBus],[SCSILogicalUnit],[SCSIPort],[SCSITargetId],[InterfaceType])
									VALUES      (cPSComputerName, cCaption, cDescription, cFirmwareRevision, cModel, cManufacturer, cPartitions, cSerialNumber, cSize, cStatus, cSCSIBus, cSCSILogicalUnit, cSCSIPort, cSCSITargetId, cInterfaceType)
		WHEN MATCHED  THEN UPDATE SET DateUpdate = GetDate();  

END
GO


GRANT EXECUTE ON OBJECT::[Computers].[dbo].[InsertPsHddLogXml]  
    TO [YOU_DOMAIN\Domain Computers];  


IF OBJECT_ID('dbo.InsertPsIpAddrLogXml', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[InsertPsIpAddrLogXml]
GO

CREATE PROCEDURE [dbo].[InsertPsIpAddrLogXml]
@xmlText nvarchar(max)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @dateUpdate DateTime;
	SET @dateUpdate = GetDate();
	DECLARE @XmlDocument xml;
	SET @XmlDocument = TRY_CONVERT(xml,@xmlText);

	MERGE  [psIPAddrLog] AS tabIp  
		USING(
	SELECT
		  tab.col.value('string((Property[@Name="PSComputerName"])[1])','NVARCHAR(250)')   AS cPSComputerName,
		  tab.col.value('string((Property[@Name="DNSHostName"])[1])','NVARCHAR(250)')	   AS cDNSHostName,
		  tab.col.value('string((Property[@Name="Description"])[1])','NVARCHAR(250)')      AS cDescription,
		  tab.col.value('string((Property[@Name="Caption"])[1])','NVARCHAR(250)')          AS cCaption,
		  tab.col.value('string((Property[@Name="DHCPEnabled"])[1])','NVARCHAR(250)')      AS cDHCPEnabled,
		  TRY_CONVERT(nvarchar(250),tab.col.query('for $val in (Property[@Name="IPAddress"]) return  concat($val, ",")'))                  cIPAddress, 
		  TRY_CONVERT(nvarchar(250),tab.col.query('for $val in (Property[@Name="IPSubnet"]) return  concat($val, ",")'))                   cIPSubnet,
		  tab.col.value('string((PROPERTY[@Name="MACAddress"])[1])','NVARCHAR(250)')       AS cMACAddress,
		  TRY_CONVERT(nvarchar(250),tab.col.query('for $val in (Property[@Name="DNSServerSearchOrder"]) return  concat($val, ",")'))       cDNSServerSearchOrder,
		  TRY_CONVERT(nvarchar(250),tab.col.query('for $val in (Property[@Name="DNSDomainSuffixSearchOrder"]) return  concat($val, ",")')) cDNSDomainSuffixSearchOrder,
		  TRY_CONVERT(nvarchar(250),tab.col.query('for $val in (Property[@Name="DefaultIPGateway"]) return  concat($val, ",")'))           cDefaultIPGateway
		  FROM
		  @XmlDocument.nodes('/Objects/Object')AS  tab(col) 
		) AS tabXmlIp 
		ON (tabIp.[PSComputerName] = tabXmlIp.cPSComputerName and 
								     tabIp.[DNSHostName] = tabXmlIp.cDNSHostName and 
									 tabIp.[Description] = tabXmlIp.cDescription and 
									 tabIp.[Caption] = tabXmlIp.cCaption and 
									 tabIp.[DHCPEnabled] = tabXmlIp.cDHCPEnabled and 
									 tabIp.[IPAddress] = tabXmlIp.cIPAddress and  
									 tabIp.[IPSubnet] = tabXmlIp.cIPSubnet and  
									 tabIp.[MACAddress] = tabXmlIp.cMACAddress	and 
									 tabIp.[DNSServerSearchOrder] = tabXmlIp.cDNSServerSearchOrder and 
									 tabIp.[DNSDomainSuffixSearchOrder] = tabXmlIp.cDNSDomainSuffixSearchOrder and tabIp.[DefaultIPGateway] = tabXmlIp.cDefaultIPGateway)
		WHEN NOT MATCHED BY TARGET THEN  INSERT ([PSComputerName],[DNSHostName],[Description],[Caption],[DHCPEnabled],[IPAddress],[IPSubnet],[MACAddress],[DNSServerSearchOrder],[DNSDomainSuffixSearchOrder],[DefaultIPGateway])
									     VALUES (cPSComputerName, cDNSHostName, cDescription, cCaption, cDHCPEnabled, cIPAddress, cIPSubnet, cMACAddress, cDNSServerSearchOrder, cDNSDomainSuffixSearchOrder, cDefaultIPGateway)
		WHEN MATCHED  THEN UPDATE SET DateUpdate = GetDate();  

END
GO

GRANT EXECUTE ON OBJECT::[Computers].[dbo].[InsertPsIpAddrLogXml]  
    TO [YOU_DOMAIN\Domain Computers];  


IF OBJECT_ID('dbo.InsertPsRamLogXml', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[InsertPsRamLogXml]
GO

CREATE PROCEDURE [dbo].[InsertPsRamLogXml]
@xmlText nvarchar(max)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @dateUpdate DateTime;
	SET @dateUpdate = GetDate();
	DECLARE @XmlDocument xml;
	SET @XmlDocument = TRY_CONVERT(xml,@xmlText);
	
	MERGE  [psRamLog] AS tabRam  
		USING(
			SELECT
				  tab.col.value('string((Property[@Name="PSComputerName"])[1])','NVARCHAR(250)')	 AS cPSComputerName,
				  tab.col.value('string((Property[@Name="BankLabel"])[1])','NVARCHAR(250)')          AS cBankLabel,
				  tab.col.value('string((Property[@Name="Capacity"])[1])','NVARCHAR(250)')           AS cCapacity,
				  tab.col.value('string((Property[@Name="DeviceLocator"])[1])','NVARCHAR(250)')      AS cDeviceLocator,
				  tab.col.value('string((Property[@Name="Model"])[1])','NVARCHAR(250)')              AS cModel,
				  tab.col.value('string((Property[@Name="Manufacturer"])[1])','NVARCHAR(250)')       AS cManufacturer,
				  tab.col.value('string((Property[@Name="FormFactor"])[1])','NVARCHAR(250)')         AS cFormFactor,
				  tab.col.value('string((Property[@Name="PartNumber"])[1])','NVARCHAR(250)')         AS cPartNumber,
				  tab.col.value('string((Property[@Name="SerialNumber"])[1])','NVARCHAR(250)')       AS cSerialNumber,
				  tab.col.value('string((Property[@Name="Speed"])[1])','NVARCHAR(250)')              AS cSpeed
			FROM  @XmlDocument.nodes('/Objects/Object')AS  tab(col) 
		) AS tabXmlRam 
		ON (tabRam.[PSComputerName] = tabXmlRam.cPSComputerName and 
									  tabRam.[BankLabel] = tabXmlRam.cBankLabel and 
									  tabRam.[Capacity] = tabXmlRam.cCapacity and 
									  tabRam.[DeviceLocator] = tabXmlRam.cDeviceLocator and
									  tabRam.[Model] = tabXmlRam.cModel and  
									  tabRam.[Manufacturer] = tabXmlRam.cManufacturer and  
									  tabRam.[FormFactor] = tabXmlRam.cFormFactor and 
									  tabRam.[PartNumber] = tabXmlRam.cPartNumber and
									  tabRam.[PartNumber] = tabXmlRam.cPartNumber and 
									  tabRam.[SerialNumber] = tabXmlRam.cSerialNumber and
									  tabRam.[Speed] = tabXmlRam.cSpeed)
		WHEN NOT MATCHED BY TARGET THEN  INSERT ([PSComputerName],[BankLabel],[Capacity],[DeviceLocator],[Model],[Manufacturer],[FormFactor],[PartNumber],[SerialNumber],[Speed])
									VALUES      (cPSComputerName, cBankLabel, cCapacity, cDeviceLocator, cModel, cManufacturer, cFormFactor, cPartNumber, cSerialNumber, cSpeed)
		WHEN MATCHED  THEN UPDATE SET DateUpdate = GetDate();  

END
GO

GRANT EXECUTE ON OBJECT::[Computers].[dbo].[InsertPsRamLogXml]  
    TO [YOU_DOMAIN\Domain Computers];  

IF OBJECT_ID('dbo.InsertPsUsersLogXml', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[InsertPsUsersLogXml]
GO

CREATE PROCEDURE [dbo].[InsertPsUsersLogXml]
@xmlText nvarchar(max)
AS
BEGIN
      SET NOCOUNT ON;
	  DECLARE @dateUpdate DateTime;
	  SET @dateUpdate = GetDate();
 	  DECLARE @XmlDocument xml;
  	  SET @XmlDocument = TRY_CONVERT(xml,@xmlText);
	

	 MERGE  [psUsersLog] AS tabUsers  
		 USING(
			 SELECT
					tab.col.value('string((Property[@Name="PSComputerName"])[1])','NVARCHAR(250)')	AS cPSComputerName,
					tab.col.value('string((Property[@Name="StartTime"])[1])','NVARCHAR(250)')	    AS cStartTime,
					tab.col.value('string((Property[@Name="DomainName"])[1])','NVARCHAR(250)')	    AS cDomainName,
					tab.col.value('string((Property[@Name="UserName"])[1])','NVARCHAR(250)')	    AS cUserName
			 FROM
				  @XmlDocument.nodes('/Objects/Object')AS  tab(col) 
		) AS tabXmlUsers 
		ON (tabUsers.[PSComputerName] = tabXmlUsers.cPSComputerName and 
										tabUsers.[StartTime] = tabXmlUsers.cStartTime and 
										tabUsers.[DomainName] = tabXmlUsers.cDomainName and 
										tabUsers.[UserName] = tabXmlUsers.cUserName)
		WHEN NOT MATCHED BY TARGET THEN  INSERT ([PSComputerName],[StartTime],[DomainName],[UserName])
									VALUES      (cPSComputerName, cStartTime, cDomainName, cUserName)
		WHEN MATCHED  THEN UPDATE SET DateUpdate = GetDate();  

END
GO

GRANT EXECUTE ON OBJECT::[Computers].[dbo].[InsertPsUsersLogXml]  
    TO [YOU_DOMAIN\Domain Computers];  


IF OBJECT_ID('dbo.InsertPsVideoLogXml', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[InsertPsVideoLogXml]
GO

CREATE PROCEDURE [dbo].[InsertPsVideoLogXml]
@xmlText nvarchar(max)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @dateUpdate DateTime;
	SET @dateUpdate = GetDate();
	DECLARE @XmlDocument xml;
	SET @XmlDocument = TRY_CONVERT(xml,@xmlText);

	 MERGE  [psVideoLog] AS tabVideo  
		 USING(
			 SELECT
				  tab.col.value('string((Property[@Name="PSComputerName"])[1])','NVARCHAR(250)')		AS cPSComputerName,
				  tab.col.value('string((Property[@Name="AdapterCompatibility"])[1])','NVARCHAR(250)')	AS cAdapterCompatibility,
				  tab.col.value('string((Property[@Name="AdapterDACType"])[1])','NVARCHAR(250)')		AS cAdapterDACType,
				  tab.col.value('string((Property[@Name="AdapterRAM"])[1])','NVARCHAR(250)')		    AS cAdapterRAM,
				  tab.col.value('string((Property[@Name="Description"])[1])','NVARCHAR(250)')			AS cDescription,
				  tab.col.value('string((Property[@Name="DriverDate"])[1])','NVARCHAR(250)')			AS cDriverDate,
				  tab.col.value('string((Property[@Name="DriverVersion"])[1])','NVARCHAR(250)')			AS cDriverVersion,
				  tab.col.value('string((Property[@Name="Name"])[1])','NVARCHAR(250)')					AS cName,
				  tab.col.value('string((Property[@Name="VideoModeDescription"])[1])','NVARCHAR(250)')	AS cVideoModeDescription,
				  tab.col.value('string((Property[@Name="VideoProcessor"])[1])','NVARCHAR(250)')		AS cVideoProcessor
				  FROM @XmlDocument.nodes('/Objects/Object')AS  tab(col) 
		) AS tabXmlVideo 
		ON (tabVideo.[PSComputerName] = tabXmlVideo.cPSComputerName and 
										tabVideo.[AdapterCompatibility] = tabXmlVideo.cAdapterCompatibility and 
										tabVideo.[AdapterDACType] = tabXmlVideo.cAdapterDACType and 
										tabVideo.[AdapterRAM] = tabXmlVideo.cAdapterRAM and 
										tabVideo.[Description] = tabXmlVideo.cDescription and 
										tabVideo.[DriverDate] = tabXmlVideo.cDriverDate and  
										tabVideo.[DriverVersion] = tabXmlVideo.cDriverVersion and  
										tabVideo.[Name] = tabXmlVideo.cName and 
										tabVideo.[VideoModeDescription] = tabXmlVideo.cVideoModeDescription and 
										tabVideo.[VideoProcessor] = tabXmlVideo.cVideoProcessor)
		WHEN NOT MATCHED BY TARGET THEN  INSERT ([PSComputerName],[AdapterCompatibility],[AdapterDACType],[AdapterRAM],[Description],[DriverDate],[DriverVersion],[Name],[VideoModeDescription],[VideoProcessor])
									VALUES      (cPSComputerName, cAdapterCompatibility, cAdapterDACType, cAdapterRAM, cDescription, cDriverDate, cDriverVersion, cName, cVideoModeDescription, cVideoProcessor)
		WHEN MATCHED  THEN UPDATE SET DateUpdate = GetDate();  

END
GO

GRANT EXECUTE ON OBJECT::[Computers].[dbo].[InsertPsVideoLogXml]  
    TO [YOU_DOMAIN\Domain Computers];  

GO