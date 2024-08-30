# Variables
GO := go
DOCKER := docker
DAPR := dapr
DOCKER_COMPOSE := docker-compose
LOG_DIR := /tmp/poc

# Create the log directory
.PHONY: setup
setup:
	@mkdir -p $(LOG_DIR)

# Build the services
.PHONY: build
build: setup
	@echo "Building API Gateway..."
	@cd api-gateway && $(GO) build -o ../bin/api-gateway
	@echo "Building GPTClient Service..."
	@cd gptclient-service && $(GO) build -o ../bin/gptclient-service
	@echo "Building ShortStories Service..."
	@cd shortstories-service && $(GO) build -o ../bin/shortstories-service
	@echo "Building Quiz Service..."
	@cd quiz-service && $(GO) build -o ../bin/quiz-service

# Run the services with Dapr
.PHONY: run
run: setup
	@echo "Running API Gateway..."
	@$(DAPR) run --app-id api-gateway --app-port 8080 --dapr-http-port 3500 --log-level debug -- ./bin/api-gateway >> $(LOG_DIR)/api-gateway.log 2>&1 &
	@echo "Running GPTClient Service..."
	@$(DAPR) run --app-id gptclient-service --app-port 8081 --dapr-http-port 3501 --log-level debug -- ./bin/gptclient-service >> $(LOG_DIR)/gptclient-service.log 2>&1 &
	@echo "Running ShortStories Service..."
	@$(DAPR) run --app-id shortstories-service --app-port 8082 --dapr-http-port 3502 --log-level debug -- ./bin/shortstories-service >> $(LOG_DIR)/shortstories-service.log 2>&1 &
	@echo "Running Quiz Service..."
	@$(DAPR) run --app-id quiz-service --app-port 8083 --dapr-http-port 3503 --log-level debug -- ./bin/quiz-service >> $(LOG_DIR)/quiz-service.log 2>&1 &

# Stop all services
.PHONY: stop
stop:
	@echo "Stopping all Dapr services..."
	@$(DAPR) stop --app-id api-gateway
	@$(DAPR) stop --app-id gptclient-service
	@$(DAPR) stop --app-id shortstories-service
	@$(DAPR) stop --app-id quiz-service

# Run the entire application with Docker Compose
.PHONY: docker-up
docker-up: setup
	@echo "Bringing up all services with Docker Compose..."
	@$(DOCKER_COMPOSE) up --build

# Stop the entire application
.PHONY: docker-down
docker-down:
	@echo "Stopping all services with Docker Compose..."
	@$(DOCKER_COMPOSE) down

# Clean up built binaries and logs
.PHONY: clean
clean:
	@echo "Cleaning up..."
	@rm -rf bin/
	@rm -rf $(LOG_DIR)/*

# Display help
.PHONY: help
help:
	@echo "Usage:"
	@echo "  make build        - Build all services"
	@echo "  make run          - Run all services with Dapr"
	@echo "  make stop         - Stop all services"
	@echo "  make docker-up    - Run all services with Docker Compose"
	@echo "  make docker-down  - Stop all services"
	@echo "  make clean        - Clean up built binaries and logs"
	@echo "  make help         - Display this help message"
