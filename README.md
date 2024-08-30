
# DrishtiVerse

## Overview
DrishtiVerse is an AI-enabled game backend built using Go, Dapr, and YugabyteDB. The project is inspired by Indian mythology, where "Drishti" means vision or insight. DrishtiVerse creates a magical, AI-driven universe powered by modern technologies.

## Technologies Used
- **Go 1.23**: The primary language used for building microservices.
- **Dapr 1.14**: A portable, event-driven runtime to build distributed applications across cloud and edge.
- **YugabyteDB 2.21.1.0**: A distributed SQL database designed for cloud-native applications.

## Project Structure

```
DrishtiVerse/
│
├── api-gateway/
│   ├── main.go
│   ├── go.mod
│   ├── go.sum
│   ├── components/
│   │   ├── statestore.yaml
│   │   └── pubsub.yaml
│   └── Dockerfile
│
├── gptclient-service/
│   ├── main.go
│   ├── go.mod
│   ├── go.sum
│   ├── components/
│   │   ├── statestore.yaml
│   │   └── pubsub.yaml
│   └── Dockerfile
│
├── shortstories-service/
│   ├── main.go
│   ├── go.mod
│   ├── go.sum
│   ├── components/
│   │   ├── statestore.yaml
│   │   └── pubsub.yaml
│   └── Dockerfile
│
├── quiz-service/
│   ├── main.go
│   ├── go.mod
│   ├── go.sum
│   ├── components/
│   │   ├── statestore.yaml
│   │   └── pubsub.yaml
│   └── Dockerfile
│
├── common/
│   ├── config/
│   │   └── config.go
│   ├── database/
│   │   ├── yugabyte.go
│   │   └── migration.sql
│   └── utils/
│       └── utils.go
│
├── Makefile
├── docker-compose.yaml
└── README.md
```

## Services

### 1. API Gateway
- **Location**: `api-gateway/`
- **Port**: 8080
- **Description**: The entry point for all client requests, routes requests to the respective microservices.

### 2. GPTClient Service
- **Location**: `gptclient-service/`
- **Port**: 8081
- **Description**: Handles communication with the GPT-3.5 API to generate content.

### 3. ShortStories Service
- **Location**: `shortstories-service/`
- **Port**: 8082
- **Description**: Manages short stories, including fetching them from the database or generating new ones if not found.

### 4. Quiz Service
- **Location**: `quiz-service/`
- **Port**: 8083
- **Description**: Manages quiz questions and answers, fetches from the database or requests new content from GPTClient service if necessary.

## Setting Up the Environment

### Prerequisites
- **Go 1.23**
- **Docker**
- **Dapr CLI**
- **YugabyteDB**

### Clone the Repository
```bash
git clone <repository-url> DrishtiVerse
cd DrishtiVerse
```

### Initialize Dapr Components
Ensure that the Dapr CLI is installed and initialized.

```bash
dapr init
```

### Running YugabyteDB Locally
Start a local YugabyteDB instance using Docker:

```bash
docker run -d --name yugabytedb -p 5433:5433 yugabytedb/yugabyte:2.21.1.0-b20 bin/yugabyted start --daemon=false
```

### Building and Running Services

1. **API Gateway**
   ```bash
   cd api-gateway
   dapr run --app-id api-gateway --app-port 8080 --dapr-http-port 3500 go run main.go
   ```

2. **GPTClient Service**
   ```bash
   cd ../gptclient-service
   dapr run --app-id gptclient-service --app-port 8081 --dapr-http-port 3501 go run main.go
   ```

3. **ShortStories Service**
   ```bash
   cd ../shortstories-service
   dapr run --app-id shortstories-service --app-port 8082 --dapr-http-port 3502 go run main.go
   ```

4. **Quiz Service**
   ```bash
   cd ../quiz-service
   dapr run --app-id quiz-service --app-port 8083 --dapr-http-port 3503 go run main.go
   ```

### Running the Entire Application with Docker Compose
You can also use Docker Compose to bring up all services together:

```bash
docker-compose up
```

### Stopping the Environment
To stop the services:

```bash
docker-compose down
```

## Contributing
Please feel free to contribute to this project by submitting pull requests, suggesting features, or reporting bugs.

## Contact
For any inquiries or support, please reach out to the maintainers.
