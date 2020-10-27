<#
    Stops one or more AWS VMs.
    Depends on the AwsPowerShell module: http://www.powershellgallery.com/packages/AWSPowerShell/
#>

# Names of the AWS EC2 VMs to stop
# TODO: replace with your EC2 VM names
$VMsToStop = @("PrIME VWB")

# Region the AWS EC2 VMs are in
# TODO: replace with the region your VMs are in
$AWSRegion = "us-east-1"

# Get creds to access AWS
$AwsCred = Get-AutomationPSCredential -Name "AwsCreds"
$AwsAccessKeyId = $AwsCred.UserName
$AwsSecretKey = $AwsCred.GetNetworkCredential().Password

# Set up the environment to access AWS
Set-AWSCredentials -AccessKey $AwsAccessKeyId -SecretKey $AwsSecretKey -StoreAs AWSProfile
Set-DefaultAWSRegion -Region $AWSRegion

# Get the AWS EC2 VMs to stop
$Instances = (Get-EC2Instance -ProfileName AWSProfile).Instances | Where-Object {
    
    $VMName = ($_.Tags | Where-Object { $_.Key -eq "Name" }).Value
    return $VMsToStop.Contains($VMName)

}

# Stop the AWS EC2 VMs
$Instances | Stop-EC2Instance -ProfileName AWSProfile -Force