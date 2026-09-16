SHELL := /bin/bash

CORE := docker compose -f compose/docker-compose.yml
CODING := $(CORE) -f compose/docker-compose.coding.yml
PRODUCTIVITY := $(CORE) -f compose/docker-compose.productivity.yml

.PHONY: up down logs ps validate coding productivity install update backup health

up:
	$(CORE) up -d

down:
	$(CORE) down

logs:
	$(CORE) logs -f

ps:
	$(CORE) ps

validate:
	$(CORE) config -q
	$(CODING) config -q
	$(PRODUCTIVITY) config -q

coding:
	$(CODING) up -d

productivity:
	$(PRODUCTIVITY) up -d

install:
	./scripts/install.sh

update:
	./scripts/update.sh

backup:
	./scripts/backup.sh

health:
	./scripts/healthcheck.sh
