function Get-Buckets {
    $buckets = @{}
    Get-ChildItem '~\scoop\buckets\' | ForEach-Object {
        $job = Start-Job -WorkingDirectory $_.FullName -ScriptBlock {
            git remote get-url origin
        }
        $remote = Receive-Job $job -Wait -AutoRemoveJob
        $buckets[$_.BaseName] = @{
            BucketName = $_.BaseName
            RemoteUrl = [string]::new($remote) # remove ps properties.
        }
    }
    return $buckets
}

function Get-Apps([string] $appsDir) {
    $apps = @{}
    Get-ChildItem $appsDir | ForEach-Object {
        $current = "$_\current"
        $installPath = "$current\install.json"
        if (Test-Path $installPath) {
            $install = Get-Content -Raw $installPath | ConvertFrom-Json -AsHashTable
            $apps[$_.name] = @{
                Name = $_.name
                Bucket = $install.bucket
                Arch = $install.architecture
            }
        }
    }
    return $apps
}

function Get-UserScopeApps {
    return Get-Apps '~\scoop\apps\'
}

function Get-GlobalScopeApps {
    $d = Get-Apps "$env:ProgramData\scoop\apps\"
    $d.Values | ForEach-Object {
        $_['Global'] = $true
    }
    return $d
}
