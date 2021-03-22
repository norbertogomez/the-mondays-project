SHELL := /bin/bash

# Makefile variables
golang_app_container := go-app

build-monday-go: ## Build Monday Go App with Podman 🛠
	@echo -e "🛠 - Building Monday Go App with Podman - 🛠\n"
	@podman build -f monday/GoAPP.Dockerfile --no-cache -t $(golang_app_container)
	@echo -e "✅ - Done - ✅\n"

help: ## Displays this help ❓
	@echo 'Usage: make [target] ...'
	@echo
	@echo 'targets:'
	@echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

kubernetes-create-go-app: ## Creates Kubernetes pod for go-app 🔌
	@echo -e "🚀 - Creating Pod for Go-App - 🚀\n"
	@docker build -f monday/GoAPP.Dockerfile --no-cache -t $(golang_app_container) monday
	@kubectl create -f devops/kubernetes/pod/go-app.yaml
	@kubectl expose pod/$(golang_app_container) --port 8080 --type=NodePort
	@echo -e "\n✅ - Done - ✅\n"

kubernetes-deploy-go-app: ## Creates a deploy of the Go App 🚀
	@echo -e "🚀 - Creating Deploy for Go-App - 🚀\n"
	@docker build -f monday/GoAPP.Dockerfile --no-cache -t $(golang_app_container) monday
	@kubectl create -f devops/kubernetes/deploy/go-app.yaml
	@kubectl expose deploy/$(golang_app_container) --port 8080 --type=NodePort
	@kubectl apply -f devops/kubernetes/ingress/ingress.yaml
	@echo -e "\n✅ - Done - ✅\n"

kubernetes-delete-deploys: ## Deletes all the deploys we have running
	@echo -e "❌ - Deleting all Deploys - ❌\n"
	@kubectl delete deploy --all
	@echo -e "\n✅ - Done - ✅\n"

kubernetes-delete-pods: ## Delete all the kubernetes pods ❌
	@echo -e "❌ - Deleting all pods - ❌\n"
	@kubectl delete pods --all
	@echo -e "\n✅ - Done - ✅\n"

kubernetes-delete-svc: ## Delete go-app kubernetes service
	@echo -e "❌ - Deleting all svc - ❌\n"
	@kubectl delete svc go-app
	@echo -e "\n✅ - Done - ✅\n"

kubernetes-describe-go-app: ## Describe current pod status 📜
	@echo -e "📜 - Go-APP Pod Status - 📜\n"
	@kubectl describe pod $(golang_app_container)
	@echo -e "\n✅ - Done - ✅\n"

kubernetes-forward-go-app: ## Make port forwarding from Kubernetes pod to local machine
	@kubectl port-forward $(golang_app_container) 8080:8080

kubernetes-list: ## Lists all the kubernetes resources 🌱️
	@echo -e "\n🌱 -️Kubernetes Resources Status - 🌱️\n"
	@kubectl get deployment,pods,svc
	@echo -e "\n✅ - Done - ✅\n"

kubernetes-logs-go-app: ## Shows the kubernetes logs of the Go App 📜
	@echo -e "📜 - Go-APP Pod Logs - 📜\n"
	@kubectl logs $(golang_app_container)
	@echo -e "\n✅ - Done - ✅\n"

kubernetes-open-go-app: ## Opens minikube exposed Go app service in browser
	@echo -e "🚀 - Opening minikube Go App Service - 🚀\n"
	@minikube service $(golang_app_container)

kubernetes-prune: kubernetes-delete-deploys kubernetes-delete-pods kubernetes-delete-svc ## Deletes all the running kubernetes things

run-monday-go: ## Runs Golang App 🏃
	@echo -e "🏃 - Running Golang App - 🏃\n"
	@podman run $(golang_app_container)
	@echo -e "\n✅ - Done - ✅\n"

start: start-kafka build-monday-go ## Starts the application 🎬.

start-kafka: ## Starts Kafka cluster 🔌
	@echo -e "🔌 - Starting Kafka Cluster - 🔌\n"
	@docker-compose -f devops/docker/kafka/docker-compose.yml up -d
	@echo -e "\n✅ - Done - ✅\n"

start-kubernetes: ## Starts Kubernetes environment 🔌
	@echo -e "🔌 - Starting Kubernetes environment - 🔌\n"
	@minikube start
	@echo -e "\n✅ - Done - ✅\n"

stop-kubernetes: ## Stops Kubernetes environment 🛑
	@echo -e "🛑 - Stopping Kubernetes environment - 🛑\n"
	@minikube stop
	@echo -e "\n✅ - Done - ✅\n"

status: ## Displays the status of all the services 💤.
	@echo -e "🐳 - Docker compose containers - 🐳\n"
	@docker-compose -f devops/docker/kafka/docker-compose.yml ps
	@echo -e "\n🌱 -️Podman Containers Status - 🌱️\n"
	@podman ps

stop: ## Stops the application and all it's components. 🛑
	@echo -e "🛑 - Stopping the application - 🛑\n"
	@docker-compose -f devops/docker/kafka/docker-compose.yml down
	@echo -e "\n✅ - Done - ✅\n"

.DEFAULT_GOAL := help
