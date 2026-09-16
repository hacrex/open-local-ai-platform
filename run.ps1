# =============================================================================
# Open Local AI Platform - Windows PowerShell Runner
# =============================================================================
# Equivalent of the Makefile for Windows (Docker Desktop).
# Usage: .\run.ps1 <command>
# Run without arguments to see available commands.
# =============================================================================

param(
    [Parameter(Position = 0)]
    [string]$Command = "help"
)

$ErrorActionPreference = "Stop"

$Core = "-f compose/docker-compose.yml"
$Coding = "$Core -f compose/docker-compose.coding.yml"
$Productivity = "$Core -f compose/docker-compose.productivity.yml"
$Vibecoding = "$Core -f compose/docker-compose.vibecoding.yml"
$Daily = "$Core -f compose/docker-compose.daily.yml"

function Invoke-Docker($args) {
    docker compose $args
    if ($LASTEXITCODE -ne 0) {
        throw "Docker compose command failed with exit code $LASTEXITCODE"
    }
}

switch ($Command.ToLower()) {
    "help" {
        Write-Host ""
        Write-Host "Open Local AI Platform - Windows Commands" -ForegroundColor Cyan
        Write-Host "=========================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "  Core:" -ForegroundColor Yellow
        Write-Host "    .\run.ps1 up              Start core services"
        Write-Host "    .\run.ps1 down            Stop and remove core containers"
        Write-Host "    .\run.ps1 stop            Stop core containers without removing"
        Write-Host "    .\run.ps1 logs            Tail core service logs"
        Write-Host "    .\run.ps1 ps              Show running containers"
        Write-Host "    .\run.ps1 pull            Pull latest images"
        Write-Host ""
        Write-Host "  Overlays:" -ForegroundColor Yellow
        Write-Host "    .\run.ps1 coding          Start core + coding (code-server)"
        Write-Host "    .\run.ps1 coding-down     Stop coding overlay"
        Write-Host "    .\run.ps1 productivity    Start core + productivity (paperless, etc.)"
        Write-Host "    .\run.ps1 prod-down       Stop productivity overlay"
        Write-Host "    .\run.ps1 vibecoding      Start core + vibecoding (TabbyML, Open Interpreter)"
        Write-Host "    .\run.ps1 vibe-down       Stop vibecoding overlay"
        Write-Host "    .\run.ps1 daily           Start core + daily (n8n, Khoj, LibreChat)"
        Write-Host "    .\run.ps1 daily-down      Stop daily overlay"
        Write-Host "    .\run.ps1 all             Start everything"
        Write-Host ""
        Write-Host "  Utilities:" -ForegroundColor Yellow
        Write-Host "    .\run.ps1 install         Run the installer (creates .env, starts core)"
        Write-Host "    .\run.ps1 update          Pull latest images and recreate containers"
        Write-Host "    .\run.ps1 backup          Back up compose config and env template"
        Write-Host "    .\run.ps1 health          Check health of running services"
        Write-Host "    .\run.ps1 validate        Validate all compose files"
        Write-Host ""
        Write-Host "  Tips:" -ForegroundColor DarkGray
        Write-Host "    .\run.ps1 logs ollama     Tail logs for a specific service"
        Write-Host "    .\run.ps1 -Command up     Full command syntax"
        Write-Host ""
    }

    "up" {
        Write-Host "Starting core services..." -ForegroundColor Green
        Invoke-Docker "$Core up -d"
    }

    "down" {
        Write-Host "Stopping and removing core containers..." -ForegroundColor Yellow
        Invoke-Docker "$Core down"
    }

    "stop" {
        Write-Host "Stopping core containers..." -ForegroundColor Yellow
        Invoke-Docker "$Core stop"
    }

    "logs" {
        if ($args.Count -gt 0) {
            Invoke-Docker "$Core logs -f $($args[0])"
        } else {
            Invoke-Docker "$Core logs -f"
        }
    }

    "ps" {
        Invoke-Docker "$Core ps"
    }

    "pull" {
        Write-Host "Pulling latest images..." -ForegroundColor Green
        Invoke-Docker "$Core pull"
    }

    "validate" {
        Write-Host "Validating compose files..." -ForegroundColor Cyan
        Invoke-Docker "$Core config -q"
        Invoke-Docker "$Coding config -q"
        Invoke-Docker "$Productivity config -q"
        Invoke-Docker "$Vibecoding config -q"
        Invoke-Docker "$Daily config -q"
        Write-Host "All compose files valid." -ForegroundColor Green
    }

    "coding" {
        Write-Host "Starting core + coding overlay..." -ForegroundColor Green
        Invoke-Docker "$Coding up -d"
    }

    "coding-down" {
        Write-Host "Stopping coding overlay..." -ForegroundColor Yellow
        Invoke-Docker "$Coding down"
    }

    "productivity" {
        Write-Host "Starting core + productivity overlay..." -ForegroundColor Green
        Invoke-Docker "$Productivity up -d"
    }

    "prod-down" {
        Write-Host "Stopping productivity overlay..." -ForegroundColor Yellow
        Invoke-Docker "$Productivity down"
    }

    "vibecoding" {
        Write-Host "Starting core + vibecoding overlay..." -ForegroundColor Green
        Invoke-Docker "$Vibecoding up -d"
    }

    "vibe-down" {
        Write-Host "Stopping vibecoding overlay..." -ForegroundColor Yellow
        Invoke-Docker "$Vibecoding down"
    }

    "daily" {
        Write-Host "Starting core + daily overlay..." -ForegroundColor Green
        Invoke-Docker "$Daily up -d"
    }

    "daily-down" {
        Write-Host "Stopping daily overlay..." -ForegroundColor Yellow
        Invoke-Docker "$Daily down"
    }

    "all" {
        Write-Host "Starting all services..." -ForegroundColor Green
        Invoke-Docker "$Daily -f compose/docker-compose.coding.yml -f compose/docker-compose.productivity.yml -f compose/docker-compose.vibecoding.yml up -d"
    }

    "install" {
        # Create .env if missing
        if (-not (Test-Path ".env")) {
            if (Test-Path ".env.example") {
                Copy-Item ".env.example" ".env"
                Write-Host "Created .env from .env.example. Review secrets before external access." -ForegroundColor Green
            } else {
                throw ".env.example not found. Cannot create .env."
            }
        }

        # Create workspace directory
        New-Item -ItemType Directory -Force -Path "workspace" | Out-Null

        # Validate compose
        Write-Host "Validating Compose files..." -ForegroundColor Cyan
        Invoke-Docker "$Core config -q"

        # Start core services
        Write-Host "Starting core services..." -ForegroundColor Green
        Invoke-Docker "$Core up -d"

        Write-Host ""
        Write-Host "Done! Services are starting up." -ForegroundColor Green
        Write-Host ""
        Write-Host "  Open WebUI:  http://localhost:3000"
        Write-Host "  Ollama API:  http://localhost:11434"
        Write-Host "  Perplexica:  http://localhost:3001"
        Write-Host "  SearXNG:     http://localhost:8080"
        Write-Host ""
    }

    "update" {
        Write-Host "Pulling latest images..." -ForegroundColor Green
        Invoke-Docker "$Core pull"
        Write-Host "Recreating containers..." -ForegroundColor Green
        Invoke-Docker "$Core up -d"
        Write-Host "Pruning unused images..." -ForegroundColor Yellow
        docker image prune -f
        Write-Host ""
        Write-Host "Update complete." -ForegroundColor Green
    }

    "backup" {
        $BackupDir = "backups\$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null

        Copy-Item -Recurse "compose" "$BackupDir\compose"
        if (Test-Path ".env.example") { Copy-Item ".env.example" "$BackupDir\.env.example" }
        if (Test-Path ".env") {
            Copy-Item ".env" "$BackupDir\.env"
            Write-Host "WARNING: .env backed up (contains secrets). Secure or delete after restore." -ForegroundColor Yellow
        }
        if (Test-Path "config") { Copy-Item -Recurse "config" "$BackupDir\config" }
        Copy-Item -Recurse "scripts" "$BackupDir\scripts"
        Copy-Item "Makefile" "$BackupDir\Makefile"

        Write-Host ""
        Write-Host "Configuration backup created at: $BackupDir" -ForegroundColor Green
        Write-Host ""
    }

    "health" {
        .\scripts\healthcheck.ps1
    }

    default {
        Write-Host "Unknown command: $Command" -ForegroundColor Red
        Write-Host "Run '.\run.ps1 help' to see available commands." -ForegroundColor Yellow
        exit 1
    }
}
