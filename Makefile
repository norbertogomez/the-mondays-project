SHELL := /bin/bash

# Makefile variables
golang_app_container := go-app

build-monday-go: ## Build Monday Go App with Podman 🛠
	@echo -e "🛠 - Building Monday Go App with Podman - 🛠\n"
	@podman build -f monday/GoAPP.Dockerfile --no-cache -t $(golang_app_container)
	@echo -e "🚀 - Done - 🚀\n"

help: ## Displays this help ❓
	@echo 'Usage: make [target] ...'
	@echo
	@echo 'targets:'
	@echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

run-monday-go: ## Runs Golang App 🏃
	@echo -e "🏃 - Running Golang App - 🏃\n"
	@podman run $(golang_app_container)
	@echo -e "🏃 - Done - 🏃\n"

start: start-kafka ## Starts the application 🎬.

start-kafka: ## Starts Kafka cluster 🔌
	@echo -e "🔌 - Starting Kafka Cluster - 🔌\n"
	@docker-compose -f devops/docker/kafka/docker-compose.yml up -d
	@echo -e "🔌 - Done - 🔌\n"

status: ## Displays the status of all the services 💤.
	@echo -e "🐳 - Docker compose containers - 🐳\n"
	@docker-compose -f devops/docker/kafka/docker-compose.yml ps
	@echo -e "\n🌱 -️Podman Containers Status - 🌱️\n"
	@podman ps

stop: ## Stops the application and all it's components. 🛑
	@echo -e "🛑 - Stopping the application - 🛑\n"
	@docker-compose -f devops/docker/kafka/docker-compose.yml down
	@echo -e "✅ - Done - ✅\n"
.DEFAULT_GOAL := help