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

function Get-Apps {
    $apps = @{}
    Get-ChildItem '~\scoop\apps\' | ForEach-Object {
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
