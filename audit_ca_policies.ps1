[CmdletBinding()]
param(
    [string]$TenantId = "9439dd25-f3b5-4829-a76f-5ede8cd54c3c"
)
$ErrorActionPreference = "Stop"

Write-Host "[*] Initiating authentication to Tenant: $TenantId..." -ForegroundColor Cyan
az login --tenant $TenantId --use-device-code | Out-Null

$tokenObj = (az account get-access-token --resource https://graph.microsoft.com --query "{accessToken:accessToken}" -o json | ConvertFrom-Json)
$graphHeaders = @{
    "Authorization" = "Bearer $($tokenObj.accessToken)"
    "Content-Type"  = "application/json"
}

Write-Host "[*] Querying Graph API for all Conditional Access Policies..." -ForegroundColor Cyan
$policiesResponse = Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies" -Headers $graphHeaders -Method Get

Write-Host "[+] Active Policy Ledger:" -ForegroundColor Green
$policiesResponse.value | Select-Object displayName, state, id | Format-Table -AutoSize