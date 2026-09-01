param(
    [Parameter(Mandatory = $true)]
    [string]$InputDirectory,

    [Parameter(Mandatory = $true)]
    [string]$OutputDirectory,

    [Parameter(Mandatory = $true)]
    [string]$ManifestPath,

    [ValidateSet('Portrait', 'Square1080', 'Square1200', 'Landscape')]
    [string]$Format = 'Portrait'
)

$ErrorActionPreference = 'Stop'

$profiles = @{
    Portrait   = @{ Width = 1080; Height = 1350; Ratio = 0.8 }
    Square1080 = @{ Width = 1080; Height = 1080; Ratio = 1.0 }
    Square1200 = @{ Width = 1200; Height = 1200; Ratio = 1.0 }
    Landscape  = @{ Width = 1200; Height = 627; Ratio = (1200 / 627) }
}

function Get-ImageSize {
    param([string]$Path)

    if ($IsMacOS) {
        $sipsOutput = & sips -g pixelWidth -g pixelHeight $Path 2>$null
        $width = [int](($sipsOutput | Select-String 'pixelWidth').ToString().Split(':')[-1].Trim())
        $height = [int](($sipsOutput | Select-String 'pixelHeight').ToString().Split(':')[-1].Trim())
        return @{ Width = $width; Height = $height }
    }

    Add-Type -AssemblyName System.Drawing
    $image = [System.Drawing.Image]::FromFile($Path)
    try {
        return @{ Width = $image.Width; Height = $image.Height }
    }
    finally {
        $image.Dispose()
    }
}

function Save-AsPng {
    param(
        [string]$SourcePath,
        [string]$DestinationPath,
        [int]$Width,
        [int]$Height
    )

    if ($IsMacOS) {
        & sips -s format png -z $Height $Width $SourcePath --out $DestinationPath | Out-Null
        return
    }

    Add-Type -AssemblyName System.Drawing
    $source = [System.Drawing.Image]::FromFile($SourcePath)
    try {
        $bitmap = New-Object System.Drawing.Bitmap($Width, $Height)
        try {
            $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
            try {
                $graphics.Clear([System.Drawing.Color]::White)
                $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
                $graphics.DrawImage($source, 0, 0, $Width, $Height)
                $bitmap.Save($DestinationPath, [System.Drawing.Imaging.ImageFormat]::Png)
            }
            finally {
                $graphics.Dispose()
            }
        }
        finally {
            $bitmap.Dispose()
        }
    }
    finally {
        $source.Dispose()
    }
}

function Assert-SetEqual {
    param(
        [string[]]$Actual,
        [string[]]$Expected,
        [string]$Message
    )

    $difference = Compare-Object -ReferenceObject ($Expected | Sort-Object) -DifferenceObject ($Actual | Sort-Object)
    if ($difference) {
        throw "$Message Expected: $($Expected -join ', '). Actual: $($Actual -join ', ')."
    }
}

if (-not (Test-Path -LiteralPath $InputDirectory -PathType Container)) {
    throw "InputDirectory does not exist: $InputDirectory"
}
if (-not (Test-Path -LiteralPath $ManifestPath -PathType Leaf)) {
    throw "ManifestPath does not exist: $ManifestPath"
}

$profile = $profiles[$Format]
$sourceFiles = Get-ChildItem -LiteralPath $InputDirectory -File |
    Where-Object { $_.Extension -match '^\.(png|jpe?g|webp)$' } |
    Sort-Object Name
if (-not $sourceFiles) {
    throw "No PNG, JPG, JPEG, or WEBP source images found in $InputDirectory"
}

try {
    $manifest = Get-Content -LiteralPath $ManifestPath -Raw | ConvertFrom-Json
}
catch {
    throw "ManifestPath is not valid JSON: $ManifestPath"
}

if ($manifest.format -ne $Format) {
    throw "Manifest format '$($manifest.format)' must match selected format '$Format'."
}
if (-not $manifest.slides -or $manifest.slides.Count -eq 0) {
    throw 'Manifest must include at least one slide with its final filename and approved visible copy.'
}
if ($manifest.copy_qa.status -ne 'pass') {
    throw "Manifest copy_qa.status must be 'pass' after full-size visual comparison before finalization."
}

$expectedNames = @($manifest.slides | ForEach-Object {
    if ([string]::IsNullOrWhiteSpace($_.file)) {
        throw 'Every manifest slide requires a non-empty final file name.'
    }
    if (-not $_.copy -or $_.copy.Count -eq 0) {
        throw "Manifest slide '$($_.file)' requires the exact approved visible copy."
    }
    $_.file
})
if (($expectedNames | Select-Object -Unique).Count -ne $expectedNames.Count) {
    throw 'Manifest final file names must be unique.'
}

$actualNames = @($sourceFiles | ForEach-Object { "$($_.BaseName).png" })
Assert-SetEqual -Actual $actualNames -Expected $expectedNames -Message 'Source images do not match the manifest slide set.'

if (Test-Path -LiteralPath $OutputDirectory) {
    if ((Get-ChildItem -LiteralPath $OutputDirectory -Force | Measure-Object).Count -gt 0) {
        throw "OutputDirectory must be empty to prevent stale or mixed delivery files: $OutputDirectory"
    }
}
else {
    New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
}

# Validate all source aspect ratios before writing anything, so a failed batch cannot look delivered.
foreach ($file in $sourceFiles) {
    $sourceSize = Get-ImageSize -Path $file.FullName
    $sourceRatio = [double]$sourceSize.Width / [double]$sourceSize.Height
    if ([math]::Abs($sourceRatio - $profile.Ratio) -gt 0.0005) {
        throw "Raw source '$($file.Name)' is $($sourceSize.Width)x$($sourceSize.Height), which is not the required $($profile.Width)x$($profile.Height) ($Format) aspect ratio. Regenerate it at the exact target size."
    }
}

$results = foreach ($file in $sourceFiles) {
    $destination = Join-Path $OutputDirectory "$($file.BaseName).png"
    Save-AsPng -SourcePath $file.FullName -DestinationPath $destination -Width $profile.Width -Height $profile.Height

    $finalSize = Get-ImageSize -Path $destination
    $bytes = (Get-Item -LiteralPath $destination).Length
    if ($finalSize.Width -ne $profile.Width -or $finalSize.Height -ne $profile.Height) {
        throw "Final file '$($file.BaseName).png' is $($finalSize.Width)x$($finalSize.Height), expected $($profile.Width)x$($profile.Height)."
    }
    if ($bytes -gt 5MB) {
        throw "Final file '$($file.BaseName).png' is $bytes bytes, above LinkedIn's 5 MB limit. Simplify and regenerate the source."
    }

    [pscustomobject]@{
        file = "$($file.BaseName).png"
        width = $finalSize.Width
        height = $finalSize.Height
        bytes = $bytes
    }
}

$report = [pscustomobject]@{
    status = 'ok'
    format = $Format
    copy_qa = $manifest.copy_qa
    requirement = 'Every file matches the selected LinkedIn dimensions, is at most 5 MB, and has passed copy QA.'
    files = $results
}

$reportPath = Join-Path $OutputDirectory 'delivery-report.json'
$report | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $reportPath -Encoding utf8
$report | ConvertTo-Json -Depth 6
