#Sign-in
Connect-AzAccount

#Provide the subscription Id where the VMs reside
$subscriptions = Get-AzSubscription

#Loop through each subscription
foreach ($sub in $subscriptions) {

    #set filename for .CSV report
    $filename = $sub.Name

    #select a context
    Select-AzSubscription $sub.Name

    #Initialize report array
    $report = @()

    #Collect VM information
    $vms = Get-AzVM

    #Loop through each VM and collect desired information
    foreach ($vm in $vms) {
        $info = "" | Select-Object VMName, ResourceGroupName, Location, VmSize, OsType
        $info.OsType = $vm.StorageProfile.OsDisk.OsType 
        $info.VMName = $vm.Name 
        $info.ResourceGroupName = $vm.ResourceGroupName 
        $info.Location = $vm.Location 
        $info.VmSize = $vm.HardwareProfile.VmSize
        $report+=$info
    }

    #Write report to CLI and to file
    # $report | Format-Table VMName, ResourceGroupName, Location, VmSize, OsType
    $report | Export-CSV "Report-$filename"
}

#Disconnect from Azure once finished
#Disconnect-AzAccount