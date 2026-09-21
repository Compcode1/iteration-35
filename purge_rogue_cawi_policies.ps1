[CmdletBinding()]
param(
    [string]$TenantId = "9439dd25-f3b5-4829-a76f-5ede8cd54c3c"
)
$ErrorActionPreference = "Stop"

# 1. Enforce Authentication
Write-Host "[*] Initiating authentication to Tenant: $TenantId..." -ForegroundColor Cyan
az login --tenant $TenantId --use-device-code | Out-Null

$tokenObj = (az account get-access-token --resource https://graph.microsoft.com --query "{accessToken:accessToken}" -o json | ConvertFrom-Json)
$graphHeaders = @{
    "Authorization" = "Bearer $($tokenObj.accessToken)"
    "Content-Type"  = "application/json"
}

# 2. Define Rogue Policy IDs
$policiesToDelete = @(
    "009be74d-1da6-4f3d-9695-10e7ce58e39c", # Legacy Iteration 31
    "8b9a855c-a41a-4589-84e1-9a81b4f76fa5", # Duplicate Iteration 31
    "5d1b92e3-a991-4c2d-9970-949279cf7c09", # Legacy Iteration 32
    "a13bd2ab-3ff0-4779-94b4-2d0136e5e52d"  # Current Network Fence (Temporary Bypass)
)

# 3. Execute Hard Deletion
Write-Host "[*] Executing Hard Deletion of Rogue and Conflicting CAWI Policies..." -ForegroundColor Yellow
foreach ($policyId in $policiesToDelete) {
    Write-Host "[-] Executing delete on Policy ID: $policyId..."
    try {
        Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies/$policyId" -Headers $graphHeaders -Method Delete
        Write-Host "    [+] Success. Policy destroyed." -ForegroundColor Green
    } catch {
        Write-Host "    [!] Failed or already deleted." -ForegroundColor Red
    }
}

Write-Host "[*] Policy purge complete. Proceed to Eventual Consistency hold." -ForegroundColor Cyan