# ScoopBackup

Scoop backup scripts.

**Note: Powershell Core is required.**

## How To Use

``` pwsh
.\ScoopBackup\Scoop-Export.ps1 > scoop.json
cat scoop.json -raw | .\ScoopBackup\Scoop-Import.ps1
```

### Global Packages

By default, only user scope packages will be export.
If you want to export with both user scope and global scope packages, you should use `-global` option:

``` pwsh
.\ScoopBackup\Scoop-Export.ps1 -global
```
