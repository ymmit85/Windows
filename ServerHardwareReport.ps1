$ArrComputers =  "srv1", "ws1"
#Specify the list of PC names in the line above. "." means local system
 
Clear-Host
foreach ($Computer in $ArrComputers)
{
    $computerSystem = get-wmiobject Win32_ComputerSystem -Computer $Computer
    $computerBIOS = get-wmiobject Win32_BIOS -Computer $Computer
    $computerOS = get-wmiobject Win32_OperatingSystem -Computer $Computer
    $cpus = get-wmiobject Win32_Processor -Computer $Computer
    $hdds = Get-WmiObject Win32_LogicalDisk -ComputerName $Computer -Filter drivetype=3
        write-host "System Information for: " $computerSystem.Name -BackgroundColor DarkCyan
        "-------------------------------------------------------"
        "Manufacturer: " + $computerSystem.Manufacturer
        "Model: " + $computerSystem.Model
        "Serial Number: " + $computerBIOS.SerialNumber
        foreach ($computercpu in $cpus) {
            " CPU Name: " + $computercpu.Name +
            " CPU MaxClockSpeed: " + $computercpu.MaxClockSpeed +
            " CPU DeviceId: " + $computercpu.DeviceID +
            " CPU SocketDesignation: "  + $computercpu.SocketDesignation
        }
        foreach ($computerhdd in $hdds) {
            "HDD Drive Letter: " + $computerhdd.DeviceID +
            " HDD Capacity: " + "{0:N2}" -f ($computerHDD.Size/1GB) + "GB" +
            " HDD Space: " + "{0:P2}" -f ($computerHDD.FreeSpace/$computerHDD.Size) +
            " Free (" + "{0:N2}" -f ($computerHDD.FreeSpace/1GB) + "GB)"
        }
        "RAM: " + "{0:N2}" -f ($computerSystem.TotalPhysicalMemory/1GB) + "GB"
        "Operating System: " + $computerOS.caption + ", Service Pack: " + $computerOS.ServicePackMajorVersion
        ""
        "-------------------------------------------------------"
}