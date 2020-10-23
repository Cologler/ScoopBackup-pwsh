# ScoopBackup

Scoop backup scripts.

**Note: Powershell Core is required.**

## How To Use

``` pwsh
.\ScoopBackup\Scoop-Export.ps1 > scoop.json
cat scoop.json -raw | .\ScoopBackup\Scoop-Import.ps1
```

### Global Packages

#### Export

By default, only user scope packages will be export.
If you want to export with both user scope and global scope packages, you should use `-global` option:

``` pwsh
.\ScoopBackup\Scoop-Export.ps1 -global
```

#### Import

By default, only user scope packages will be import.
If you want to import global scope packages, you should use `-global` option:

``` pwsh
cat scoop.json -raw | .\ScoopBackup\Scoop-Import.ps1 -global
```

For owner reason, when you use `-global` option, **ONLY** global will be import.
