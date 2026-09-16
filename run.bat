@echo off
REM =============================================================================
REM Open Local AI Platform - Windows Quick Start
REM =============================================================================
REM Double-click this file or run: run.bat <command>
REM Requires: Docker Desktop running
REM =============================================================================

if "%1"=="" goto help
goto %1

:help
echo.
echo   Open Local AI Platform - Windows Quick Start
echo   =============================================
echo.
echo   Usage: run.bat ^<command^>
echo.
echo   Commands:
echo     install       First-time setup (creates .env, starts core)
echo     up            Start core services
echo     down          Stop and remove containers
echo     coding        Start core + coding overlay
echo     productivity  Start core + productivity overlay
echo     vibecoding    Start core + vibecoding overlay
echo     daily         Start core + daily overlay
echo     all           Start everything
echo     update        Pull latest images
echo     health        Check service health
echo     ps            Show running containers
echo.
echo   Examples:
echo     run.bat install
echo     run.bat all
echo     run.bat down
echo.
goto end

:install
echo Checking Docker...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker Desktop is not running or not installed.
    echo Install: https://www.docker.com/products/docker-desktop/
    goto end
)
if not exist .env (
    if exist .env.example (
        copy .env.example .env >nul
        echo Created .env from .env.example
    )
)
if not exist workspace mkdir workspace
echo Starting core services...
docker compose -f compose/docker-compose.yml up -d
echo.
echo Done! Open http://localhost:3000 in your browser.
goto end

:up
docker compose -f compose/docker-compose.yml up -d
goto end

:down
docker compose -f compose/docker-compose.yml down
goto end

:stop
docker compose -f compose/docker-compose.yml stop
goto end

:logs
docker compose -f compose/docker-compose.yml logs -f
goto end

:ps
docker compose -f compose/docker-compose.yml ps
goto end

:pull
docker compose -f compose/docker-compose.yml pull
goto end

:coding
docker compose -f compose/docker-compose.yml -f compose/docker-compose.coding.yml up -d
goto end

:coding-down
docker compose -f compose/docker-compose.yml -f compose/docker-compose.coding.yml down
goto end

:productivity
docker compose -f compose/docker-compose.yml -f compose/docker-compose.productivity.yml up -d
goto end

:prod-down
docker compose -f compose/docker-compose.yml -f compose/docker-compose.productivity.yml down
goto end

:vibecoding
docker compose -f compose/docker-compose.yml -f compose/docker-compose.vibecoding.yml up -d
goto end

:vibe-down
docker compose -f compose/docker-compose.yml -f compose/docker-compose.vibecoding.yml down
goto end

:daily
docker compose -f compose/docker-compose.yml -f compose/docker-compose.daily.yml up -d
goto end

:daily-down
docker compose -f compose/docker-compose.yml -f compose/docker-compose.daily.yml down
goto end

:all
docker compose -f compose/docker-compose.yml -f compose/docker-compose.coding.yml -f compose/docker-compose.productivity.yml -f compose/docker-compose.vibecoding.yml -f compose/docker-compose.daily.yml up -d
goto end

:update
docker compose -f compose/docker-compose.yml pull
docker compose -f compose/docker-compose.yml up -d
docker image prune -f
goto end

:health
powershell -ExecutionPolicy Bypass -File scripts\healthcheck.ps1
goto end

:validate
docker compose -f compose/docker-compose.yml config -q
docker compose -f compose/docker-compose.yml -f compose/docker-compose.coding.yml config -q
docker compose -f compose/docker-compose.yml -f compose/docker-compose.productivity.yml config -q
docker compose -f compose/docker-compose.yml -f compose/docker-compose.vibecoding.yml config -q
docker compose -f compose/docker-compose.yml -f compose/docker-compose.daily.yml config -q
echo All compose files valid.
goto end

:end
