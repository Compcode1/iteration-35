<#
.SYNOPSIS
    Zero-Trust Machine Identity Provisioning & OIDC Federation via Native PowerShell REST API
.DESCRIPTION
    Automates Microsoft Entra ID Application registration, Service Principal creation, 
    OpenID Connect workload federation credential mapping for GitHub Actions, and Azure Key Vault data-plane RBAC.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$TenantId = "9439dd25-f3b5-4829-a76f-5ede8cd54c3c",
    
    [Parameter(Mandatory=$false)]
    [string]$SubscriptionId = "d5ffd8a5-d994-4eb5-b87c-4442054d233e",
    
    [Parameter(Mandatory=$false)]
    [string]$ResourceGroupName = "rg-efm-test-lab-04",
    
    [Parameter(Mandatory=$false)]
    [string]$KeyVaultName = "kv-efm-test-lab-04",
    
    [Parameter(Mandatory=$false)]
    [string]$AppName = "acphf-rest-agent-01",
    
    [Parameter(Mandatory=$false)]
    [string]$RepoNumericId = "1376161460"
)

# 1. Enforce Authentication via Device Code Flow (Mandating MFA claims)
Write-Host "[*] Initiating authentication to Tenant: $TenantId..." -ForegroundColor Cyan
az login --tenant $TenantId --use-device-code | Out-Null

$tokenObj = (az account get-access-token --resource https://graph.microsoft.com --query "{accessToken:accessToken}" -o json | ConvertFrom-Json)
$graphToken = $tokenObj.accessToken

$armTokenObj = (az account get-access-token --resource https://management.azure.com --query "{accessToken:accessToken}" -o json | ConvertFrom-Json)
$armToken = $armTokenObj.accessToken

$graphHeaders = @{
    "Authorization" = "Bearer $graphToken"
    "Content-Type"  = "application/json"
}

$armHeaders = @{
    "Authorization" = "Bearer $armToken"
    "Content-Type"  = "application/json"
}

# 2. Create Microsoft Entra Application Object
Write-Host "[*] Creating Entra Application: $AppName..." -ForegroundColor Cyan
$appBody = @{
    displayName = $AppName
    signInAudience = "AzureADMyOrg"
} | ConvertTo-Json

$appResponse = Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/applications" -Headers $graphHeaders -Method Post -Body $appBody
$appId = $appResponse.appId
$appObjectId = $appResponse.id
Write-Host "[+] Application Created. Client ID: $appId | Object ID: $appObjectId" -ForegroundColor Green

# 3. Create Service Principal Object
Write-Host "[*] Provisioning Enterprise Service Principal..." -ForegroundColor Cyan
$spBody = @{
    appId = $appId
} | ConvertTo-Json

$spResponse = Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/servicePrincipals" -Headers $graphHeaders -Method Post -Body $spBody
$spObjectId = $spResponse.id
Write-Host "[+] Service Principal Created. Object ID: $spObjectId" -ForegroundColor Green

# 4. Configure OIDC Federated Credential
Write-Host "[*] Configuring OIDC Federated Credential for GitHub Actions..." -ForegroundColor Cyan
$federatedSubject = "repo:Compcode1/iteration-35@${RepoNumericId}:ref:refs/heads/main"
$fedBody = @{
    name = "github-actions-main-fed"
    issuer = "https://token.actions.githubusercontent.com"
    subject = $federatedSubject
    description = "GitHub Actions OIDC Federation for ACPHF Agent"
    audiences = @("api://AzureADTokenExchange")
} | ConvertTo-Json

$fedUri = "https://graph.microsoft.com/v1.0/applications/$appObjectId/federatedIdentityCredentials"
$fedResponse = Invoke-RestMethod -Uri $fedUri -Headers $graphHeaders -Method Post -Body $fedBody
Write-Host "[+] Federated Credential Active. Subject: $federatedSubject" -ForegroundColor Green

# 5. Assign Data-Plane RBAC Role (Key Vault Secrets User)
Write-Host "[*] Assigning Key Vault Secrets User role via ARM REST API..." -ForegroundColor Cyan
$roleDefinitionId = "/subscriptions/$SubscriptionId/providers/Microsoft.Authorization/roleDefinitions/4633458b-17de-408a-b874-0444c86b69e6"
$roleAssignmentName = [guid]::NewGuid().ToString()
$scope = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.KeyVault/vaults/$KeyVaultName"

$rbacBody = @{
    properties = @{
        roleDefinitionId = $roleDefinitionId
        principalId = $spObjectId
        principalType = "ServicePrincipal"
    }
} | ConvertTo-Json

$rbacUri = "https://management.azure.com${scope}/providers/Microsoft.Authorization/roleAssignments/${roleAssignmentName}?api-version=2022-04-01"
$rbacResponse = Invoke-RestMethod -Uri $rbacUri -Headers $armHeaders -Method Put -Body $rbacBody
Write-Host "[+] Data-Plane RBAC Assignment Successful!" -ForegroundColor Green
Write-Host "[*] Deployment Complete. Application ID (Client ID): $appId" -ForegroundColor Yellow