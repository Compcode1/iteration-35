# DEFECT & PATCH LEDGER (DPL)
**Session Run:** 2026-09-18 | **Framework:** ACPHF V8.0

### ENTRY 1: Terminal MFA Claim Drop & Role Assignment Failure
*   **Error:** `RequestDisallowedByAzure` 401 on ARM REST API Role Assignment.
*   **Root Cause:** Local terminal credential brokers inherently drop strict tenant-level MFA `amr` claims during token exchange, violating ARM's strict authentication constraints for executing control-plane role assignments via native API.
*   **Engineered Fix:** Decoupled the deployment per Framework Rule 29. Automated the Entra ID identity provisioning via native PowerShell REST API, and shifted the data-plane mapping to a manual Azure Portal UI runbook to satisfy the MFA gate natively.

### ENTRY 2: Omission of Explicit Git Workflow Runbook & Stacked Halts
*   **Error:** Ambiguous CI/CD validation instructions causing execution failure.
*   **Root Cause:** AI Engine violated Rule 18 by assuming Git/UI knowledge instead of providing explicit terminal keystrokes, and violated the Single-Action Halt constraint by stacking pipeline validation and portal metrics validation in one phase block.
*   **Engineered Fix:** Segmented Phase 4 validation into strictly isolated sequence halts. Generated explicit terminal runbook for directory creation, file initialization, and Git remote synchronization to trigger the pipeline.

### ENTRY 3: Diagnostic Iteration Counter Misaligned
*   **Error:** Circuit Breaker tracking triggered prematurely across disjointed errors.
*   **Root Cause:** The engine carried over the iteration count from the previous Azure Portal MFA diagnostic into a completely new diagnostic loop, breaking the localized Circuit Breaker protocol.
*   **Engineered Fix:** Enforced strict isolation of the diagnostic iteration counter, mandating a reset to Iteration 1 for every newly declared `[ACTIVE DIAGNOSTIC]` string.

### ENTRY 4: YAML File Initialization Protocol Failure
*   **Error:** Ambiguous file initialization directions and failure to explicitly forecast workspace requirements.
*   **Root Cause:** The engine buried critical file creation instructions inside Bash comments instead of formally declaring the file creation step per Rule 12, resulting in a disjointed and confusing execution flow.
*   **Engineered Fix:** Stripped file creation steps out of script comments. Restructured the pipeline deployment runbook into explicit, sequential phases (Directory Creation -> Payload Injection -> Remote Sync) before ultimately pivoting to the Web UI based on environmental constraints.

### ENTRY 5: Brownfield App ID Mismatch & Duplicate State
*   **Error:** Application ID mismatch & `AADSTS700213` Subject Claim mismatch.
*   **Root Cause:** Engine failed to ingest the explicitly provided Brownfield Client ID (`cfb0eb5e-cde1-47f3-9eea-3ac1eba2525f`) and `@171821203` Owner ID template during Phase 3, generating a duplicate greenfield application and flawed YAML payload.
*   **Engineered Fix:** Synchronized the federated credential in the correct Brownfield Entra Application via Azure Portal and patched the GitHub Actions YAML with the correct Client ID. Pipeline successfully authenticated and executed.

### ENTRY 6: DPL Code Block Rendering Failure
*   **Error:** Defect & Patch Ledger (DPL) rendered without a copy-paste code block.
*   **Root Cause:** The AI Engine persistently violated Rule 21 (Explicit File Labeling & Formatting) by failing to securely wrap the DPL payload in standard markdown code block fencing, disabling the one-click copy UI element.
*   **Engineered Fix:** Logged the protocol deviation, appended the defect to the ledger, and explicitly forced the code block formatting for the DPL payload generation.