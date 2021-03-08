SHELL := /bin/bash

help: ## Displays this help
	@echo 'Usage: make [target] ...'
	@echo
	@echo 'targets:'
	@echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

start: start-kafka ## Runs all the application.

start-kafka: ## Starts Kafka cluster
	@docker-compose -f devops/docker/kafka/docker-compose.yml up -d

status: ## Displays the status of all the services.
	@docker-compose -f devops/docker/kafka/docker-compose.yml ps

stop: ## Stops the application and all it's components.
	@docker-compose -f devops/docker/kafka/docker-compose.yml down

.DEFAULT_GOAL := help