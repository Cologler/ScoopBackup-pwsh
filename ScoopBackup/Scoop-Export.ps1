. $PSScriptRoot\Lib.ps1

function ScoopExport {
    $buckets = Get-Buckets
    $apps = Get-UserScopeApps

    $apps.Values | ForEach-Object {
        $app = $_
        if ($buckets.ContainsKey($app.Bucket)) {
            # if user remove bucket, unable to backup
            $bucket = $buckets[$app.Bucket]
            if (!$bucket.ContainsKey("Apps")) {
                $bucket["Apps"] = @{}
            }
            $bucket.Apps[$app.Name] = @{
                #Version = $app.Version # scoop did not support select version
                Arch = $app.Arch
            }
        }
    }

    $rv = @{
        Version = 1
        Buckets = @{}
    }
    $buckets.Values | ForEach-Object {
        $bucket = $_
        $url = $bucket.RemoteUrl
        if (!$rv.Buckets.ContainsKey($url)) {
            $rv.Buckets[$url] = $bucket
        }
    }

    return $rv | ConvertTo-Json -Depth 10
}

$ea = $ErrorActionPreference
$ErrorActionPreference = 'Stop'
try {
    ScoopExport
}
finally {
    $ErrorActionPreference = $ea
}
