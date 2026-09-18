# IDENTITY ARCHITECTURE LEDGER (IAL)
Immutable cryptographic baseline recording for the AI and Cloud Pipeline Hardening Framework (ACPHF).
Deployment Target: GitHub Actions | Target Cloud: Microsoft Azure

Execution Date: 2026-09-18 | Ledger State: [VERIFIED AUDIT READY]

## [SECTION 1: CORE CLOUD BOUNDARY IDENTIFICATION]
**1.1 Deterministic Routing Coordinates**
Anchoring the globally unique root coordinates via active CLI discovery commands.
*   **Tenant ID (Identity Root):** `9439dd25-f3b5-4829-a76f-5ede8cd54c3c`
*   **Subscription ID (Asset Root):** `d5ffd8a5-d994-4eb5-b87c-4442054d233e`

**1.2 Target Asset Configuration Profile**
*   **Provisioned Resource Name:** `kv-efm-test-lab-04`
*   **Resource Group Perimeter:** `rg-efm-test-lab-04`

**HARD BOOLEAN Workspace Path Cryptography**
Are both the target subscription asset and the identity directory actively nested under the identical root tenant domain structure?
> **[SUCCESS]** Workspace paths align. CLI context locked.

## [SECTION 2: NON-HUMAN IDENTITY PROVISIONING]
**2.1 Identity Object Profile**
Automated instantiation of the machine account and local execution context.
*   **Application Name:** `acphf-rest-agent-01`
*   **Application (Client) ID:** `cfb0eb5e-cde1-47f3-9eea-3ac1eba2525f`

**2.2 Architectural Attack Surface Minimization**
*   **Single-Tenant Enforced:** (AzureADMyOrg) Blocks external credential instantiation.
*   **Headless Execution (Blank Redirect URI):** Denies interactive browser callback vectors.

**HARD BOOLEAN Object Instantiation State**
Has the programmatic execution successfully initialized both the central Application Object and the local enterprise Service Principal?
> **[SUCCESS]** Blueprint and local security context created.

## [SECTION 3: PASSWORDLESS CRYPTOGRAPHIC FEDERATION]
**3.1 Federated Trust Parameters**
*   **Issuer URL:** `https://token.actions.githubusercontent.com`
*   **Audience Mapping:** `api://AzureADTokenExchange`

**3.2 Immutable Subject Claim Mapping**
Explicit, case-sensitive string configuration for inbound OIDC handshakes.
*   **Subject (sub):** `repo:Compcode1@171821203/iteration-35@<NEW_REPO_NUMERIC_ID>:ref:refs/heads/main`
*   **Applied State:** `repo:Compcode1@171821203/iteration-35@1376161460:ref:refs/heads/main`
*   Subject claim contains zero production wildcards (*).
*   Exact string casing verified to prevent AADSTS700213 drops.

**HARD BOOLEAN Policy Enforcement**
Has the cryptographic JSON payload been successfully written into the federated identity collection?
> **[SUCCESS]** Trust policy active. Token endpoint listening.

## [SECTION 4: DATA-PLANE ACCESS & PIPELINE ENFORCEMENT]
**4.1 Role-Based Access Control (RBAC) Entitlements**
Bypassing infrastructure control planes in favor of strict data-plane isolation.
*   **Assigned Data-Plane Role:** `Key Vault Secrets User` (Manual Portal Override / MFA Gate Compliant Execution)
*   **Target Asset ID Scope:** `/subscriptions/d5ffd8a5-d994-4eb5-b87c-4442054d233e/resourceGroups/rg-efm-test-lab-04/providers/Microsoft.KeyVault/vaults/kv-efm-test-lab-04`

**4.2 Token Volatility & Secret Masking**
*   Access Token ceiling restricted to 60-minutes.
*   Script-level runtime masking (::add-mask::) actively intercepting memory variables.

**HARD BOOLEAN Telemetry Verification**
Has KQL logging confirmed a successful authentication mapping directly against the assigned data-plane asset?
> **[SUCCESS]** HTTP 200 recorded. Zero Silent 403 drops detected.