# ScoopBackup

Scoop backup scripts.

**Note: Powershell Core is required.**

## How To Use

``` pwsh
# for export
.\ScoopBackup\Scoop-Export.ps1 > scoop.json

# for import
.\ScoopBackup\Scoop-Import.ps1 scoop.json
```

### Export

By default, only user scope packages will be export.
If you want to export with both user scope and global scope packages, you can use `-global` switch:

``` pwsh
.\ScoopBackup\Scoop-Export.ps1 -global
```

### Import

By default, only user scope packages will be import.
If you want to import global scope packages, you can use `-global` switch:

``` pwsh
.\ScoopBackup\Scoop-Import.ps1 scoop.json -global
```

When you use `-global` option, **ONLY** global packages will be import.
