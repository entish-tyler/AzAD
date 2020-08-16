[CmdletBinding()]

param(
    [Parameter(Mandatory=$True)]
    [Alias("AzADUPN")]
    [String]
    ${Enter Azure AD Admin UPN},
    [Parameter(Mandatory=$True)]
    [Alias("UserName")]
    [String]
    ${Enter UPN of User Token to Revoke}
    )

Connect-Azuread -AccountId $AzADUPN

$TokenStart=(Get-AzureADUser -SearchString "$UserName").RefreshTokensValidFromDateTime
Write-host "$UserName original token created on $TokenStart"
(Get-AzureADUser -SearchString "$UserName").ObjectId | Revoke-AzureADUserAllRefreshToken
$NewToken=(Get-AzureADUser -SearchString "$UserName").RefreshTokensValidFromDateTime
Write-host "$UserName new token created on $NewToken"