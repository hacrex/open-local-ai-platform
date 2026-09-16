SHELL := /bin/bash

CORE := docker compose -f compose/docker-compose.yml
CODING := $(CORE) -f compose/docker-compose.coding.yml
PRODUCTIVITY := $(CORE) -f compose/docker-compose.productivity.yml

.PHONY: help up down stop logs ps pull validate coding coding-down \
        productivity productivity-down install update backup health lint

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

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
	@echo "All compose files valid."

coding: ## Start core + coding overlay
	$(CODING) up -d

coding-down: ## Stop coding overlay containers
	$(CODING) down

productivity: ## Start core + productivity overlay
	$(PRODUCTIVITY) up -d

productivity-down: ## Stop productivity overlay containers
	$(PRODUCTIVITY) down

install: ## Run the installer (creates .env, starts core)
	./scripts/install.sh

update: ## Pull latest images and recreate containers
	./scripts/update.sh

backup: ## Back up compose config and env template
	./scripts/backup.sh

health: ## Check health of all services
	./scripts/healthcheck.sh

lint: ## Lint shell scripts (requires shellcheck)
	@command -v shellcheck >/dev/null 2>&1 || { echo "Install shellcheck: https://www.shellcheck.net/"; exit 1; }
	shellcheck -s bash scripts/*.sh

compose-lint: ## Lint compose files (requires docker compose)
	docker compose -f compose/docker-compose.yml config -q
	docker compose -f compose/docker-compose.yml -f compose/docker-compose.coding.yml config -q
	docker compose -f compose/docker-compose.yml -f compose/docker-compose.productivity.yml config -q
	@echo "All compose files valid."
