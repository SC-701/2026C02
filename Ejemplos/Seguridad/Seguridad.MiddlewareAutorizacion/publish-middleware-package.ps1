param(
    [string]$RepositoryRoot = "D:\Code\2026C02\Ejemplos\Seguridad\Seguridad.MiddlewareAutorizacion",
    [string]$GitHubOwner = "Drojascode",
    [string]$Version,
    [switch]$UpdateFeed,
    [string]$GitHubPat,
    [switch]$SkipDuplicate = $true,
    [ValidateSet('Autorizacion.Middleware','Autorizacion.DA','Autorizacion.Flujo','Autorizacion.Abstracciones')]
    [string]$ProjectName = 'Autorizacion.Middleware'
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($GitHubPat))
{
    $secureToken = Read-Host 'GitHub PAT' -AsSecureString
    $GitHubPat = [System.Net.NetworkCredential]::new('', $secureToken).Password
}

$projectPath = Join-Path $RepositoryRoot "$ProjectName\$ProjectName.csproj"
$packageSource = "https://nuget.pkg.github.com/$GitHubOwner/index.json"
$feedName = "GitHub-$GitHubOwner"

function Ensure-NuGetSource {
    param(
        [string]$Name,
        [string]$Source,
        [string]$Username,
        [string]$Password
    )

    & dotnet nuget remove source $Name | Out-Null

    $addArgs = @(
        'nuget', 'add', 'source', $Source,
        '--name', $Name,
        '--username', $Username,
        '--password', $Password,
        '--store-password-in-clear-text'
    )

    & dotnet @addArgs
    if ($LASTEXITCODE -ne 0) {
        throw "No se pudo actualizar ni crear el feed '$Name' en '$Source'."
    }
}

if (-not [string]::IsNullOrWhiteSpace($Version))
{
    [xml]$projectXml = Get-Content $projectPath -Raw
    $versionNode = $projectXml.Project.PropertyGroup | Where-Object { $_.Version } | Select-Object -First 1

    if ($null -eq $versionNode)
    {
        throw 'No se encontró el nodo <Version> en el archivo .csproj.'
    }

    $versionNode.Version = $Version
    $projectXml.Save($projectPath)
}

[xml]$currentProjectXml = Get-Content $projectPath -Raw
$currentVersion = ($currentProjectXml.Project.PropertyGroup | Where-Object { $_.Version } | Select-Object -First 1).Version

if ($UpdateFeed)
{
    Write-Host "Actualizando el feed $feedName ..." -ForegroundColor Cyan
    Ensure-NuGetSource -Name $feedName -Source $packageSource -Username $GitHubOwner -Password $GitHubPat
}

Write-Host 'Restaurando y generando el paquete...' -ForegroundColor Cyan
dotnet pack $projectPath -c Release

$packagePath = Join-Path $RepositoryRoot "$ProjectName\bin\Release\$ProjectName.$currentVersion.nupkg"

if (-not (Test-Path $packagePath))
{
    throw "No se encontró el paquete esperado: $packagePath"
}

$pushArgs = @(
    'nuget', 'push', $packagePath,
    '--source', $packageSource,
    '--api-key', $GitHubPat
)

if ($SkipDuplicate)
{
    $pushArgs += '--skip-duplicate'
}

Write-Host "Publicando en $packageSource ..." -ForegroundColor Cyan
dotnet @pushArgs