SHELL := /bin/bash

CORE := docker compose -f compose/docker-compose.yml
CODING := $(CORE) -f compose/docker-compose.coding.yml
PRODUCTIVITY := $(CORE) -f compose/docker-compose.productivity.yml
VIBECODING := $(CORE) -f compose/docker-compose.vibecoding.yml
DAILY := $(CORE) -f compose/docker-compose.daily.yml

.PHONY: help up down stop logs logs-% ps pull validate coding coding-down \
        productivity productivity-down vibecoding vibecoding-down \
        daily daily-down all install update backup health lint

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-22s\033[0m %s\n", $$1, $$2}'

up: ## Start core services
	$(CORE) up -d

down: ## Stop and remove core containers
	$(CORE) down

stop: ## Stop core containers without removing
	$(CORE) stop

logs: ## Tail core service logs
	$(CORE) logs -f

logs-%: ## Tail logs for a specific service (e.g., make logs-ollama)
	$(CORE) logs -f $*

ps: ## Show running containers
	$(CORE) ps

pull: ## Pull latest images for core services
	$(CORE) pull

validate: ## Validate all compose files
	$(CORE) config -q
	$(CODING) config -q
	$(PRODUCTIVITY) config -q
	$(VIBECODING) config -q
	$(DAILY) config -q
	@echo "All compose files valid."

# --- Overlays ---

coding: ## Start core + coding overlay (code-server)
	$(CODING) up -d

coding-down: ## Stop coding overlay containers
	$(CODING) down

productivity: ## Start core + productivity overlay (paperless, blinko, etc.)
	$(PRODUCTIVITY) up -d

productivity-down: ## Stop productivity overlay containers
	$(PRODUCTIVITY) down

vibecoding: ## Start core + vibecoding overlay (TabbyML, Open Interpreter)
	$(VIBECODING) up -d

vibecoding-down: ## Stop vibecoding overlay containers
	$(VIBECODING) down

daily: ## Start core + daily driver overlay (n8n, Khoj, LibreChat)
	$(DAILY) up -d

daily-down: ## Stop daily driver overlay containers
	$(DAILY) down

all: ## Start all overlays (core + coding + productivity + vibecoding + daily)
	$(DAILY) -f compose/docker-compose.coding.yml -f compose/docker-compose.productivity.yml -f compose/docker-compose.vibecoding.yml up -d

# --- Utilities ---

install: ## Run the installer (creates .env, starts core)
	./scripts/install.sh

update: ## Pull latest images and recreate containers
	./scripts/update.sh

backup: ## Back up compose config and env template
	./scripts/backup.sh

health: ## Check health of running services
	./scripts/healthcheck.sh

lint: ## Lint shell scripts (requires shellcheck)
	@command -v shellcheck >/dev/null 2>&1 || { echo "Install shellcheck: https://www.shellcheck.net/"; exit 1; }
	shellcheck -s bash scripts/*.sh
