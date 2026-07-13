#Requires -Version 7.0
<#
.SYNOPSIS
    Crea el repositorio template Template.SPA con Vite + React + TypeScript
    (modo estricto de la Constitution §4) y personalización completa de Copilot.

.DESCRIPTION
    Genera la siguiente estructura:
      src/     → vacío; el alumno ejecuta npm create vite tras clonar la plantilla
      .github/ → copilot-instructions, prompts, agents, skills, workflows
      .specify/memory/ → constitution.md
      docs/    → templates, adr, stories, use-cases

    No incluye scaffold de Vite ni dependencias npm. El alumno ejecuta
    npm create vite@latest . -- --template react-ts dentro de su repo clonado.

.PARAMETER Ruta
    Directorio donde se creará la carpeta Template.SPA.
    Por defecto: directorio de trabajo actual.

.EXAMPLE
    .\New-TallerTemplateSpa.ps1
    .\New-TallerTemplateSpa.ps1 -Ruta "C:\Repos"
#>
[CmdletBinding()]
param(
    [string] $Ruta = (Get-Location).Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$pilotoDocs = Resolve-Path (Join-Path $PSScriptRoot '..\docs')
$nombreRepo = 'Template.SPA'
$destino    = Join-Path $Ruta $nombreRepo

# ── Prerrequisitos ─────────────────────────────────────────────────────────────
Write-Host '🔍 Verificando prerrequisitos...' -ForegroundColor Cyan

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw 'Git no encontrado. Instalalo desde https://git-scm.com'
}
Write-Host "   ✅ $(git --version)"

if (Test-Path $destino) {
    throw "La carpeta '$destino' ya existe. Eliminala o usá otra -Ruta."
}

# ── Crear carpeta del proyecto ───────────────────────────────────────────────────────
New-Item -ItemType Directory -Path $destino | Out-Null
Push-Location $destino
Write-Host "`n📁 Destino: $destino" -ForegroundColor Cyan

try {

    # ── src/ vacío ────────────────────────────────────────────────────────────
    # La plantilla no incluye scaffold de Vite. El alumno lo ejecuta tras clonar:
    #   npm create vite@latest . -- --template react-ts
    Write-Host "`n📂 Preparando src/..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Path 'src' -Force | Out-Null
    '' | Set-Content 'src/.gitkeep' -Encoding UTF8
    Write-Host '   ✅ src/ listo (vacío — el alumno ejecuta npm create vite aquí)'

    # ── .gitignore ─────────────────────────────────────────────────────────────
    (@(
        '# Dependencias'
        'node_modules/'
        ''
        '# Build'
        'dist/'
        'build/'
        ''
        '# Cobertura'
        'coverage/'
        ''
        '# Secretos — NUNCA versionar (Constitution §8)'
        '.env.production'
        '.env.staging'
        '.env.local'
        ''
        '# Editor'
        '.vscode/settings.json'
        '.idea/'
        ''
        '# OS'
        '.DS_Store'
        'Thumbs.db'
    ) -join "`n") | Set-Content '.gitignore' -Encoding UTF8

    # ── .npmrc — registro aprobado ────────────────────────────────────────────
    (@(
        '# .npmrc — apuntar al registro aprobado por la organización (Constitution §8.4)'
        '# Cambiar la URL si la organización usa un registro privado (Artifactory, Nexus, etc.)'
        'registry=https://registry.npmjs.org/'
    ) -join "`n") | Set-Content '.npmrc' -Encoding UTF8


    # ── .github/ — Personalización de Copilot ─────────────────────────────────
    Write-Host "`n🤖 Copiando personalización de Copilot..." -ForegroundColor Cyan
    @('instructions', 'prompts', 'agents', 'skills', 'workflows') | ForEach-Object {
        New-Item -ItemType Directory -Path ".github/$_" -Force | Out-Null
    }

    # Instrucciones activas (frontend)
    Copy-Item "$pilotoDocs/instructions/copilot-instructions.frontend.md" `
              '.github/copilot-instructions.md'
    Copy-Item "$pilotoDocs/instructions/copilot-instructions.frontend.md" `
              '.github/instructions/copilot-instructions.frontend.md'

    # Prompts relevantes para frontend + historias
    @(
        'generar-historia-de-usuario.prompt.md',
        'generar-caso-de-uso.prompt.md',
        'generar-prueba-desde-ac.prompt.md',
        'generar-componente-funcional.prompt.md',
        'generar-custom-hook.prompt.md'
    ) | ForEach-Object {
        Copy-Item "$pilotoDocs/Prompts/$_" ".github/prompts/$_"
    }

    # Agents
    Copy-Item "$pilotoDocs/agents/programador-spa-react.agent.md" '.github/agents/'
    Copy-Item "$pilotoDocs/agents/analista-requisitos.agent.md"   '.github/agents/'

    # Skills y workflows
    Get-ChildItem "$pilotoDocs/skills/*.skill.md" | Copy-Item -Destination '.github/skills/'
    Get-ChildItem "$pilotoDocs/workflows/*.md"    | Copy-Item -Destination '.github/workflows/'

    $nSkills = (Get-ChildItem '.github/skills').Count
    Write-Host "   ✅ .github/ → 5 prompts | 2 agentes | $nSkills skills | workflows"

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
    git commit -m 'chore: bootstrap Template.SPA' | Out-Null
    Write-Host '   ✅ Commit inicial: chore: bootstrap Template.SPA'

    # ── Resumen ────────────────────────────────────────────────────────────────
    Write-Host "`n✅ Template.SPA listo en: $destino" -ForegroundColor Green
    Write-Host ''
    Write-Host '   Próximos pasos para publicar como template en GitHub:' -ForegroundColor Yellow
    Write-Host '   1. gh repo create SC-701/Template.SPA --private --source=. --push'
    Write-Host '   2. En GitHub → Settings → marcar "Template repository"'
    Write-Host '   3. El alumno usará "Use this template" → "Create a new repository"'
    Write-Host '   4. Clonar desde https://github.com/SC-701/Template.SPA y ejecutar: npm create vite@latest . -- --template react-ts'

} finally {
    Pop-Location
}
