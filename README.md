# wmi-xml-db 
## Файл psCreateTablesMsSQL.sql 

Позволяет создать набор таблиц для записи WMI данных компьютера.
**Если таблица с таким именем существует, она удалится**

Будут созданы таблицы в базе данных **Computers**:
1) **psBiosLog**  Для получения из класса Win32_BIOS следующих значений: "PSComputerName","Manufacturer","Name","SerialNumber","Version","Description","SMBIOSBIOSVersion","SMBIOSMajorVersion"

2) **psCpuLog** Для получения из класса Win32_Processor следующих значений: 
PSComputerName","Manufacturer","Name","DeviceID","NumberOfCores","NumberOfLogicalProcessors","CurrentClockSpeed","L2CacheSize","L3CacheSize"

3) **psHddLog** Для получения из класса Win32_DiskDrive следующих значений: 
PSComputerName","Description","FirmwareRevision","Model","Manufacturer","Partitions","SerialNumber","Size","Status","SCSIBus","SCSILogicalUnit","SCSIPort","SCSITargetId","InterfaceType"

4) **psIPAddrLog** Для получения из класса Win32_DiskDrive следующих значений: 
"PSComputerName","DNSHostName","Description","Caption","DHCPEnabled","IPAddress","IPSubnet","MACAddress","DNSServerSearchOrder","DNSDomainSuffixSearchOrder","DefaultIPGateway"

5) **psRamLog** Для получения из класса Win32_PhysicalMemory следующих значений: 
"PSComputerName","BankLabel","Capacity","DeviceLocator","Model","Manufacturer","FormFactor","PartNumber","SerialNumber","Speed"

6) **psUsersLog** Для получения данных из классов  Win32_LoggedOnUser и Win32_LogonSession 
"PSComputerName","StartTime","DomainName","UserName"

7) **psVideoLog** Для получения из класса Win32_PhysicalMemory следующих значений: 
"PSComputerName","AdapterCompatibility","AdapterDACType","AdapterRAM","Description","DriverDate","DriverVersion","Name","VideoModeDescription","VideoProcessor"


## Файл psCreateSpMsSQL.sql

Позволяет создать хранимые процедуры для вставки XML файлов в базу данных:

XML файл должен быть вида:

```xml
<Objects>
  <Object>
    <Property Name="PSComputerName">WIN-E3RPT5J1UC0</Property>
    <Property Name="Name">Default System BIOS</Property>
    <Property Name="SerialNumber">ABC87234HHGT</Property>
    <Property Name="Version">030717 - 20170307</Property>
    <Property Name="Description">Default System BIOS</Property>
    <Property Name="SMBIOSBIOSVersion">080016 </Property>
    <Property Name="SMBIOSMajorVersion">2</Property>
  </Object>
</Objects>
```

Хранимая процедура делает два действия:
1) Извлекает данные из XML файла
2) С помощью MERGE объеденяет данные (добавляет строки если нет такой записи, или обновляет дату если существует)

В итоге осуществляется одна отправка XML файла, а вся обработка происходит на сервере 
