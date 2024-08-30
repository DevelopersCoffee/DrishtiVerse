
# DrishtiVerse Requirements

## Overview
This document outlines the requirements for implementing the DrishtiVerse architecture in Go using Dapr. DrishtiVerse is an AI-enabled game backend inspired by Indian mythology, leveraging Dapr for service invocation, state management, and event-driven communication.

## 1. Services Breakdown

### a. API Gateway
- **Role**: Entry point for clients (mobile, web).
- **Functionality**: Routes requests to the appropriate microservices (GPTClient, ShortStories, Quiz).
- **Implementation**: 
  - Simple Go service.
  - Uses Dapr's service invocation for downstream communication.
  - Handles routing logic for directing requests.

### b. GPTClient Service
- **Role**: Communicates with the GPT API (e.g., GPT-3.5 Turbo) to generate content.
- **Implementation**: 
  - Go microservice interacting with the OpenAI API.
  - Uses Dapr’s service-to-service invocation.
  - Implements fallback logic or caching for API errors.

### c. ShortStories Service
- **Role**: Manages short stories, including database fetches and generation of new content.
- **Implementation**: 
  - Go microservice.
  - Uses Dapr state management for CRUD operations.
  - Integrates with GPTClient Service if the story is not found.
  - Publishes events to the Event Bus for new content.

### d. Quiz Service
- **Role**: Manages quiz questions and answers.
- **Implementation**: 
  - Similar to the ShortStories Service.
  - Uses Dapr state management for storing and retrieving quiz data.
  - Requests new quiz content from GPTClient Service if necessary.
  - Publishes events to the Event Bus for new quizzes.

### e. Event Bus (Pub/Sub)
- **Role**: Decouples services and handles events.
- **Implementation**: 
  - Dapr's pub/sub component.
  - Configured to enable communication between services.
  - Handles events like "NewStoryCreated" or "NewQuizCreated".

### f. SQL Server
- **Role**: Stores data for the ShortStories and Quiz services.
- **Implementation**: 
  - Uses Dapr’s state store components to connect to SQL Server.
  - Each microservice has its own database or schema, as needed.

## 2. Dapr Components

### a. State Store
- **Usage**: For storing quiz questions and short stories.
- **Components**: SQL Server, Redis (optional).

### b. Pub/Sub
- **Usage**: Acts as the Event Bus.
- **Components**: Redis Streams, Kafka (optional).

### c. Bindings
- **Usage**: To trigger certain functions based on external events.
- **Note**: May be less relevant for this use case.

## 3. Defining the Architecture

### a. API Gateway
- Implement a Go service for the API Gateway.
- Use Dapr’s service invocation for downstream microservices (GPTClient, ShortStories, Quiz).
- Implement routing logic.

### b. GPTClient Service
- Implement a Go microservice that interacts with the GPT API.
- Use Dapr service invocation for service-to-service calls.
- Implement caching or fallback logic.

### c. ShortStories Service
- Implement a Go microservice managing short stories.
- Use Dapr state management for CRUD operations.
- Integrate with GPTClient Service for new content.
- Publish events to the Event Bus.

### d. Quiz Service
- Implement a Go microservice managing quizzes.
- Use Dapr state management for storing/retrieving quiz data.
- Integrate with GPTClient Service for new content.
- Publish events to the Event Bus.

### e. Event Bus (Pub/Sub)
- Configure Dapr's pub/sub component for inter-service communication.
- Ensure proper event handling for content generation.

### f. SQL Server
- Use Dapr’s state store components for SQL Server integration.
- Manage separate databases or schemas for ShortStories and Quiz services.

## 4. Sample Implementation Steps in Go + Dapr

### API Gateway Example:
```go
package main

import (
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	dapr "github.com/dapr/go-sdk/client"
)

func main() {
	r := gin.Default()
	client, err := dapr.NewClient()
	if err != nil {
		panic(err)
	}

	r.GET("/short-stories/:id", func(c *gin.Context) {
		id := c.Param("id")
		resp, err := client.InvokeMethod(c, "shortstories-service", "stories/"+id, "get")
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, gin.H{"story": string(resp)})
	})

	r.Run(":8080") // API Gateway running on port 8080
}
```

### Dapr Configuration:
- Use `dapr run` commands for each service with necessary components (e.g., pub/sub, state store).

```bash
dapr run --app-id api-gateway --app-port 8080 --dapr-http-port 3500 go run main.go
```

### Event Bus Configuration:
- Define `pubsub.yaml` for the pub/sub component (e.g., Redis):

```yaml
apiVersion: dapr.io/v1alpha1
kind: Component
metadata:
  name: pubsub
  namespace: default
spec:
  type: pubsub.redis
  version: v1
  metadata:
  - name: redisHost
    value: "redis:6379"
  - name: redisPassword
    value: ""
```

## 5. Deployment

### Local Development:
- Use Docker Compose with Dapr components for local testing.

### Kubernetes:
- Deploy services with Dapr sidecars in Kubernetes.
- Ensure correct Dapr components are deployed (state store, pub/sub).

## Summary
Following this architecture will result in a scalable, decoupled microservices system in Go, leveraging Dapr for service invocation, state management, and event-driven communication.
