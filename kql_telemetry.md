# KQL TELEMETRY ARTIFACT
**Target Asset:** kv-efm-test-lab-04
**Execution Agent App ID:** cfb0eb5e-cde1-47f3-9eea-3ac1eba2525f

```kusto
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.KEYVAULT"
| where Resource == "KV-EFM-TEST-LAB-04"
| where identity_claim_appid_g == "cfb0eb5e-cde1-47f3-9eea-3ac1eba2525f"
| project TimeGenerated, OperationName, identity_claim_appid_g, ResultSignature, CallerIPAddress
| order by TimeGenerated desc