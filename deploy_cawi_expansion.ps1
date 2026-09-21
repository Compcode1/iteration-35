[CmdletBinding()]
param(
    [string]$TenantId = "9439dd25-f3b5-4829-a76f-5ede8cd54c3c",
    [string]$AppId = "cfb0eb5e-cde1-47f3-9eea-3ac1eba2525f"
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

# 2. Extract the Service Principal Object ID
Write-Host "[*] Resolving Service Principal Object ID..." -ForegroundColor Cyan
$spQueryUri = "https://graph.microsoft.com/v1.0/servicePrincipals?`$filter=appId eq '$AppId'"
$spResponse = Invoke-RestMethod -Uri $spQueryUri -Headers $graphHeaders -Method Get
$spObjectId = $spResponse.value[0].id
Write-Host "[+] Service Principal Object ID resolved: $spObjectId" -ForegroundColor Green

# 3. Idempotency Check: Fetch Existing Named Location
Write-Host "[*] Verifying Named Location state..." -ForegroundColor Cyan
$allLocations = Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/identity/conditionalAccess/namedLocations" -Headers $graphHeaders -Method Get
$existingLocation = $allLocations.value | Where-Object { $_.displayName -eq "GitHub Actions Meta IPs (ACPHF Limit 80)" }

if ($existingLocation) {
    $namedLocationId = $existingLocation.id
    Write-Host "[+] Found existing Named Location ID: $namedLocationId (Skipping creation)" -ForegroundColor Green
} else {
    Write-Host "[!] ERROR: Named location missing. Please delete policies and restart." -ForegroundColor Red
    exit 1
}

# 4. Deploy CAWI Network Fence Policy
Write-Host "[*] Deploying CAWI Network Fence Policy..." -ForegroundColor Cyan
$cawiNetworkBody = @{
    "displayName" = "ACPHF-CAWI-Network-Fence"
    "state" = "enabled"
    "conditions" = @{
        "clientApplications" = @{ "includeServicePrincipals" = @($spObjectId) }
        "applications" = @{ "includeApplications" = @("All") }
        "users" = @{ "includeUsers" = @("None") }
        "locations" = @{
            "includeLocations" = @("All")
            "excludeLocations" = @($namedLocationId)
        }
    }
    "grantControls" = @{
        "operator" = "OR"
        "builtInControls" = @("block")
    }
} | ConvertTo-Json -Depth 6

try {
    Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies" -Headers $graphHeaders -Method Post -Body $cawiNetworkBody | Out-Null
    Write-Host "[+] CAWI Network Fence Deployed successfully." -ForegroundColor Green
} catch {
    $err = $_.ErrorDetails.Message | ConvertFrom-Json
    Write-Host "[!] Graph API Error: $($err.error.message)" -ForegroundColor Red
    exit 1
}

# 5. Deploy Workload Identity Risk Policy
Write-Host "[*] Deploying Workload Identity High-Risk Block Policy..." -ForegroundColor Cyan
$cawiRiskBody = @{
    "displayName" = "ACPHF-CAWI-Risk-Block"
    "state" = "enabled"
    "conditions" = @{
        "clientApplications" = @{ "includeServicePrincipals" = @($spObjectId) }
        "applications" = @{ "includeApplications" = @("All") }
        "users" = @{ "includeUsers" = @("None") }
        "servicePrincipalRiskLevels" = @("high")
    }
    "grantControls" = @{
        "operator" = "OR"
        "builtInControls" = @("block")
    }
} | ConvertTo-Json -Depth 6

try {
    Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies" -Headers $graphHeaders -Method Post -Body $cawiRiskBody | Out-Null
    Write-Host "[+] CAWI Risk Policy Deployed successfully." -ForegroundColor Green
} catch {
    $err = $_.ErrorDetails.Message | ConvertFrom-Json
    Write-Host "[!] Graph API Error: $($err.error.message)" -ForegroundColor Red
    exit 1
}

Write-Host "[*] Day-2 Capability Expansion Complete." -ForegroundColor Yellow