USE [Computers]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('dbo.psBiosLog', 'U') IS NOT NULL 
  DROP TABLE [dbo].[psBiosLog];
GO  
CREATE TABLE [dbo].[psBiosLog](
	[ID] int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[PSComputerName] nvarchar(250) NOT NULL,
	[Name] nvarchar(250) NULL,
	[SerialNumber] nvarchar(250) NULL,
	[Version] nvarchar(250) NULL,
	[Description] nvarchar(250) NULL,
	[SMBIOSBIOSVersion] nvarchar(250) NULL,
	[SMBIOSMajorVersion] nvarchar(250) NULL,
	[DateAdd] [datetime] DEFAULT (getdate()) NULL,
	[DateUpdate] [datetime] NULL
)

IF OBJECT_ID('dbo.psCpuLog', 'U') IS NOT NULL 
  DROP TABLE [dbo].[psCpuLog];
GO
  
CREATE TABLE [psCpuLog](
	[ID] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[PSComputerName] nvarchar(250) NULL,
	[Manufacturer] nvarchar(250) NULL,
	[Name] nvarchar(250) NULL,
	[DeviceID] nvarchar(250) NULL,
	[NumberOfCores] nvarchar(250) NULL,
	[NumberOfLogicalProcessors] nvarchar(250) NULL,
	[CurrentClockSpeed] nvarchar(250) NULL,
	[L2CacheSize] nvarchar(250) NULL,
	[L3CacheSize] nvarchar(250) NULL,
	[DateAdd] datetime DEFAULT (getdate()) NULL,
	[DateUpdate] datetime NULL
)

IF OBJECT_ID('dbo.psHddLog', 'U') IS NOT NULL 
  DROP TABLE [dbo].[psHddLog];
GO

CREATE TABLE [psHddLog](
	[ID] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[PSComputerName] nvarchar(250) NOT NULL,
	[Caption] nvarchar(250) NULL,
	[Description] nvarchar(250) NULL,
	[FirmwareRevision] nvarchar(250) NULL,
	[Model] nvarchar(250) NULL,
	[Manufacturer] nvarchar(250) NULL,
	[Partitions] nvarchar(250) NULL,
	[SerialNumber] nvarchar(250) NULL,
	[Size] nvarchar(250) NULL,
	[Status] nvarchar(250) NULL,
	[SCSIBus] nvarchar(250) NULL,
	[SCSILogicalUnit] nvarchar(250) NULL,
	[SCSIPort] nvarchar(250) NULL,
	[SCSITargetId] nvarchar(250) NULL,
	[InterfaceType] nvarchar(250) NULL,
	[DateAdd] datetime DEFAULT (getdate()) NULL,
	[DateUpdate] datetime NULL
)

IF OBJECT_ID('dbo.psIPAddrLog', 'U') IS NOT NULL 
  DROP TABLE [dbo].[psIPAddrLog];
GO

CREATE TABLE [psIPAddrLog](
	[ID] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[PSComputerName] nvarchar(250) NULL,
	[DNSHostName] nvarchar(250) NULL,
	[Description] nvarchar(250) NULL,
	[Caption] nvarchar(250) NULL,
	[DHCPEnabled] nvarchar(250) NULL,
	[IPAddress] nvarchar(250) NULL,
	[IPSubnet] nvarchar(250) NULL,
	[MACAddress] nvarchar(250) NULL,
	[DNSServerSearchOrder] nvarchar(250) NULL,
	[DNSDomainSuffixSearchOrder] nvarchar(250) NULL,
	[DefaultIPGateway] nvarchar(250) NULL,
	[DateAdd] datetime DEFAULT (getdate()) NULL,
	[DateUpdate] datetime NULL
)

IF OBJECT_ID('dbo.psRamLog', 'U') IS NOT NULL 
  DROP TABLE [dbo].[psRamLog];
GO

CREATE TABLE [psRamLog](
	[ID] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[PSComputerName] nvarchar(250) NOT NULL,
	[BankLabel] nvarchar(250) NULL,
	[Capacity] nvarchar(250) NULL,
	[DeviceLocator] nvarchar(250) NULL,
	[Model] nvarchar(250) NULL,
	[Manufacturer] nvarchar(250) NULL,
	[FormFactor] nvarchar(250) NULL,
	[PartNumber] nvarchar(250) NULL,
	[SerialNumber] nvarchar(250) NULL,
	[Speed] nvarchar(250) NULL,
	[DateAdd] datetime DEFAULT (getdate()) NULL,
	[DateUpdate] [datetime] NULL
)

IF OBJECT_ID('dbo.psUsersLog', 'U') IS NOT NULL 
  DROP TABLE [dbo].[psUsersLog];
GO

CREATE TABLE [dbo].[psUsersLog](
	[ID] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[PSComputerName] nvarchar(250) NOT NULL,
	[StartTime] nvarchar(250) NULL,
	[DomainName] nvarchar(250) NULL,
	[UserName] nvarchar(250) NULL,
	[DateAdd] datetime DEFAULT (getdate()) NULL,
	[DateUpdate] datetime NULL
)

IF OBJECT_ID('dbo.psVideoLog', 'U') IS NOT NULL 
  DROP TABLE [dbo].[psVideoLog];
GO
CREATE TABLE [dbo].[psVideoLog](
	[ID] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[PSComputerName] nvarchar(250) NOT NULL,
	[AdapterCompatibility] nvarchar(250) NULL,
	[AdapterDACType] nvarchar(250) NULL,
	[AdapterRAM] nvarchar(250) NULL,
	[Description] nvarchar(250) NULL,
	[DriverDate] nvarchar(250) NULL,
	[DriverVersion] nvarchar(250) NULL,
	[Name] nvarchar(250) NULL,
	[VideoModeDescription] nvarchar(250) NULL,
	[VideoProcessor] nvarchar(250) NULL,
	[DateAdd] datetime DEFAULT (getdate()) NULL,
	[DateUpdate] datetime NULL
)