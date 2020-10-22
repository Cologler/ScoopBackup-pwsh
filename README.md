# ScoopBackup

Scoop backup scripts.

**Note: Powershell Core is required.**

## How To Use

``` pwsh
.\ScoopBackup\Scoop-Export.ps1 > scoop.json
cat scoop.json -raw | .\ScoopBackup\Scoop-Import.ps1
```
