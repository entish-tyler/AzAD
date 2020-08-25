[CmdletBinding()]

param(
    [Parameter(Mandatory=$True)]
    [Alias("UserName")]
    [String]
    ${Enter UPN of User Token to Revoke}
    )

Connect-Azuread

$TokenStart=(Get-AzureADUser -SearchString "$UserName").RefreshTokensValidFromDateTime
Write-host "$UserName original token created on $TokenStart"
(Get-AzureADUser -SearchString "$UserName").ObjectId | Revoke-AzureADUserAllRefreshToken
$NewToken=(Get-AzureADUser -SearchString "$UserName").RefreshTokensValidFromDateTime
Write-host "$UserName new token created on $NewToken"

Set-AzureADUser -ObjectId $UserName -AccountEnabled $false

$UserDevices=(Get-AzureADUserRegisteredDevice -ObjectId $UserName).DisplayName

Write-Host "$UserDevices will be disabled in Azure Active Directory"

Get-AzureADUserRegisteredDevice -ObjectId $UserName | Set-AzureADDevice -AccountEnabled $false
