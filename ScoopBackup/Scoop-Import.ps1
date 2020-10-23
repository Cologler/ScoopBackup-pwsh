param(
    [parameter(ValueFromPipeline=$true)][string] $plainText
)

. $PSScriptRoot\Lib.ps1

function ImportBuckets {
    param (
        [hashtable] $bucketsToImport # map url to name
    )

    $existsBuckets = Get-Buckets
    $bucketsMapUrl2Name = @{}
    $existsBuckets.Values | ForEach-Object {
        $bucketsMapUrl2Name[$_.RemoteUrl] = $_.BucketName
    }

    $bucketsToImport.Keys | ForEach-Object {
        $url = $_
        $name = $bucketsToImport[$_]

        if (!$bucketsMapUrl2Name.ContainsKey($url)) {
            if ($existsBuckets.ContainsKey($name)) {
                throw [System.NotImplementedException]::new("bucket name conflict: $name")
            }
            scoop bucket add $name $url
            $bucketsMapUrl2Name[$url] = $name
        }
    }

    return $bucketsMapUrl2Name
}

function ScoopInstall {
    Write-Verbose "Installing $args"
    scoop install @args
    Write-Host ""
}

function ScoopImportV1([hashtable] $data) {
    $bucketsToImport = @{}
    $data.Buckets.Values | ForEach-Object {
        $bucketsToImport[$_.RemoteUrl] = $_.BucketName
    }

    $bucketsMapUrl2Name = ImportBuckets $bucketsToImport
    $existsApps = Get-UserScopeApps

    $data.Buckets.Values | ForEach-Object {
        $bucketName = $bucketsMapUrl2Name[$_.RemoteUrl]

        if ($_.Apps) {
            $apps = $_.Apps
            $apps.Keys | ForEach-Object {
                if (!$existsApps.ContainsKey($_)) {
                    ScoopInstall "$bucketName/$_" --arch $apps[$_].Arch
                }
            }
        }
    }

    if ($data.NoBucketApps) {
        $data.NoBucketApps.Keys | ForEach-Object {
            $appName = $_
            $app = $data.NoBucketApps[$_]

            if (!$existsApps.ContainsKey($appName)) {
                if ($app.Url) {
                    ScoopInstall $app.Url --arch $app.Arch
                }
            }
        }
    }
}

function ScoopImport {
    param(
        [parameter(ValueFromPipeline=$true)][string] $plainText
    )

    $data = $plainText | ConvertFrom-Json -AsHashtable
    if ($data.Version -eq 1) {
        ScoopImportV1 $data
    } else {
        throw "Unknown version."
    }
}

$ea = $ErrorActionPreference
$ErrorActionPreference = 'Stop'
try {
    ScoopImport $plainText
}
finally {
    $ErrorActionPreference = $ea
}
