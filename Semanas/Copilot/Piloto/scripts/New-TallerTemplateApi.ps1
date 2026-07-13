#Requires -Version 7.0
<#
.SYNOPSIS
    Crea el repositorio template Template.API con arquitectura de 6 capas,
    proyectos de prueba y personalización completa de Copilot del taller.

.DESCRIPTION
    Genera la siguiente estructura:
      src/     → vacío; el alumno crea sus proyectos .NET con el nombre de su dominio
      .github/ → copilot-instructions, prompts, agents, skills, workflows
      .specify/memory/ → constitution.md
      docs/    → templates, adr, stories, use-cases

    No incluye proyectos .NET ni tests. Sin renombrado necesario: el alumno
    crea directamente sus capas (ej. AlbumMundial.Api) desde cero en src/.

.PARAMETER Ruta
    Directorio donde se creará la carpeta Template.API.
    Por defecto: directorio de trabajo actual.

.EXAMPLE
    .\New-TallerTemplateApi.ps1
    .\New-TallerTemplateApi.ps1 -Ruta "C:\Repos"
#>
[CmdletBinding()]
param(
    [string] $Ruta = (Get-Location).Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$pilotoDocs = Resolve-Path (Join-Path $PSScriptRoot '..\docs')
$destino    = Join-Path $Ruta 'Template.API'

# ── Prerrequisitos ─────────────────────────────────────────────────────────────
Write-Host '🔍 Verificando prerrequisitos...' -ForegroundColor Cyan

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw 'Git no encontrado. Instalalo desde https://git-scm.com'
}
Write-Host "   ✅ $(git --version)"

if (Test-Path $destino) {
    throw "La carpeta '$destino' ya existe. Eliminala o usá otra -Ruta."
}

# ── Crear carpeta y entrar ─────────────────────────────────────────────────────
New-Item -ItemType Directory -Path $destino | Out-Null
Push-Location $destino
Write-Host "`n📁 Destino: $destino" -ForegroundColor Cyan

try {

    # ── src/ vacío ────────────────────────────────────────────────────────────
    # La plantilla no incluye proyectos .NET. El alumno crea sus propios proyectos
    # con el nombre de su dominio (ej. AlbumMundial.Api) en src/ al usar la plantilla.
    Write-Host "`n📂 Preparando src/..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Path 'src' -Force | Out-Null
    '' | Set-Content 'src/.gitkeep' -Encoding UTF8
    Write-Host '   ✅ src/ listo (vacío — el alumno crea sus proyectos aquí)'

    # ── .editorconfig ─────────────────────────────────────────────────────────
    @'
root = true

[*]
indent_style = space
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

[*.{cs,csproj,sln}]
indent_size = 4

[*.{json,yml,yaml,md}]
indent_size = 2
'@ | Set-Content '.editorconfig' -Encoding UTF8

    # ── .gitignore ─────────────────────────────────────────────────────────────
    @'
# Build
bin/
obj/
*.user
*.suo
.vs/

# Cobertura y resultados de pruebas
coverage/
TestResults/
*.trx
*.opencover.xml

# Secretos — NUNCA versionar (Constitution §8)
.env
.env.*
appsettings.Production.json
appsettings.Staging.json
!appsettings.Development.json

# OS
.DS_Store
Thumbs.db
'@ | Set-Content '.gitignore' -Encoding UTF8

    # ── .github/ — Personalización de Copilot ─────────────────────────────────
    Write-Host "`n🤖 Copiando personalización de Copilot..." -ForegroundColor Cyan
    @('instructions', 'prompts', 'agents', 'skills', 'workflows') | ForEach-Object {
        New-Item -ItemType Directory -Path ".github/$_" -Force | Out-Null
    }

    # Instrucciones activas (backend)
    Copy-Item "$pilotoDocs/instructions/copilot-instructions.backend.md" `
              '.github/copilot-instructions.md'
    Copy-Item "$pilotoDocs/instructions/copilot-instructions.backend.md" `
              '.github/instructions/copilot-instructions.backend.md'

    # Prompts relevantes para backend + historias
    @(
        'generar-historia-de-usuario.prompt.md',
        'generar-caso-de-uso.prompt.md',
        'generar-prueba-desde-ac.prompt.md',
        'implementar-para-pasar-prueba.prompt.md'
    ) | ForEach-Object {
        Copy-Item "$pilotoDocs/Prompts/$_" ".github/prompts/$_"
    }

    # Agents
    Copy-Item "$pilotoDocs/agents/programador-mapi.agent.md"    '.github/agents/'
    Copy-Item "$pilotoDocs/agents/analista-requisitos.agent.md" '.github/agents/'

    # Skills y workflows
    Get-ChildItem "$pilotoDocs/skills/*.skill.md" | Copy-Item -Destination '.github/skills/'
    Get-ChildItem "$pilotoDocs/workflows/*.md"    | Copy-Item -Destination '.github/workflows/'

    $nSkills = (Get-ChildItem '.github/skills').Count
    Write-Host "   ✅ .github/ → 4 prompts | 2 agentes | $nSkills skills | workflows"

    # ── .specify/memory/ — Constitution ───────────────────────────────────────
    New-Item -ItemType Directory -Path '.specify/memory' -Force | Out-Null
    Copy-Item "$pilotoDocs/constitution.md" '.specify/memory/constitution.md'
    Write-Host '   ✅ .specify/memory/constitution.md'

    # ── docs/ — Templates y ADRs ──────────────────────────────────────────────
    Write-Host "`n📚 Copiando docs..." -ForegroundColor Cyan
    @('docs/templates', 'docs/adr', 'docs/stories', 'docs/use-cases') | ForEach-Object {
        New-Item -ItemType Directory -Path $_ -Force | Out-Null
    }
    Get-ChildItem "$pilotoDocs/templates/*.md" | Copy-Item -Destination 'docs/templates/'
    Get-ChildItem "$pilotoDocs/adr/*.md"       | Copy-Item -Destination 'docs/adr/'
    '' | Set-Content 'docs/stories/.gitkeep'   -Encoding UTF8
    '' | Set-Content 'docs/use-cases/.gitkeep' -Encoding UTF8

    $nTemplates = (Get-ChildItem 'docs/templates').Count
    $nAdrs      = (Get-ChildItem 'docs/adr').Count
    Write-Host "   ✅ docs/ → $nTemplates templates | $nAdrs ADRs"

    # ── Commit inicial ─────────────────────────────────────────────────────────
    Write-Host "`n📦 Inicializando Git..." -ForegroundColor Cyan
    git init -b main | Out-Null
    git add .        | Out-Null
    git commit -m 'chore: bootstrap Template.API' | Out-Null
    Write-Host '   ✅ Commit inicial: chore: bootstrap Template.API'

    # ── Resumen ────────────────────────────────────────────────────────────────
    Write-Host "`n✅ Template.API listo en: $destino" -ForegroundColor Green
    Write-Host ''
    Write-Host '   Próximos pasos para publicar como template en GitHub:' -ForegroundColor Yellow
    Write-Host '   1. gh repo create SC-701/Template.API --private --source=. --push'
    Write-Host '   2. En GitHub → Settings → marcar "Template repository"'
    Write-Host '   3. El alumno usará "Use this template" → "Create a new repository"'
    Write-Host '   4. Clonar desde https://github.com/SC-701/Template.API y crear los proyectos .NET con dotnet new en src/ usando el nombre del dominio.'

} finally {
    Pop-Location
}
