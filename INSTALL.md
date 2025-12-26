# Installation and Quick Start Guide

This guide will help you install prerequisites and run the Compose for Agents demos.

## Quick Start

### 1. Check Prerequisites

Run the installation check script to verify your system meets the requirements:

```bash
./install.sh
```

This script checks for:

- Docker (4.43.0+ recommended)
- Docker Compose (2.38.1+ required)
- GPU support (optional, but recommended for local models)

### 2. Run a Demo

Use the quick-start script to run any demo:

```bash
./run.sh [demo-name]
```

For example:

```bash
./run.sh agno
```

### Available Demos

- **a2a** - Multi-Agent Fact Checker
- **agno** - GitHub issues summarizer
- **vercel** - Chat UI with local models
- **crew-ai** - Marketing Strategy Agent
- **adk** - Multi-Agent Fact Checker
- **langgraph** - SQL Agent
- **langchaingo** - DuckDuckGo Search
- **spring-ai** - Brave Search
- **embabel** - Travel Agent
- **minions** - Cost-Efficient Local-Remote Collaboration
- **adk-cerebras** - Golang Experts
- **adk-sock-shop** - Sock Store Agent
- **akka** - Akka demo

### Options

```bash
./run.sh [demo-name] [options]
```

Available options:

- `--openai` - Use OpenAI models instead of local models
- `--build` - Force rebuild of containers
- `--detach` or `-d` - Run in detached/background mode

Examples:

```bash
# Run with OpenAI models
./run.sh agno --openai

# Run in background
./run.sh vercel --detach

# Force rebuild and run
./run.sh crew-ai --build
```

## Manual Installation

If you prefer to set up manually, follow these steps:

### Prerequisites

1. **Install Docker Desktop** (4.43.0+) or **Docker Engine**
   + Download from: <https://www.docker.com/products/docker-desktop/>
   + For Linux users, also install Docker Compose 2.38.1+

2. **GPU Support** (optional but recommended)
   + For local model execution
   + Or use [Docker Offload](https://www.docker.com/products/docker-offload/)

### Running a Demo Manually

1. Choose a demo directory:

   ```bash
   cd ./agno
   ```

2. Create configuration (if needed):

   ```bash
   # If mcp.env.example exists:
   cp mcp.env.example .mcp.env
   # Edit .mcp.env with your API keys
   ```

3. Run with Docker Compose:

   ```bash
   docker compose up --build
   ```

### Using OpenAI Models

Some demos support OpenAI models instead of local models:

1. Create an OpenAI API key file:

   ```bash
   echo "sk-your-api-key-here" > secret.openai-api-key
   ```

2. Run with OpenAI configuration:

   ```bash
   docker compose -f compose.yaml -f compose.openai.yaml up
   ```

## Troubleshooting

### Docker is not running

Start Docker Desktop or the Docker daemon:

```bash
# On Linux
sudo systemctl start docker

# On macOS/Windows: Start Docker Desktop application
```

### Permission denied

Make sure the scripts are executable:

```bash
chmod +x install.sh run.sh
```

### GPU not detected

- On **macOS**: Metal GPU acceleration is used automatically
- On **Linux/Windows**: Install NVIDIA drivers and nvidia-docker
- **Alternative**: Use Docker Offload for cloud-based GPU access

### Port already in use

If you see port conflicts, stop other running demos:

```bash
docker compose down
```

Or check what's using the port:

```bash
# On Linux/macOS
lsof -i :3000

# On Windows
netstat -ano | findstr :3000
```

## Next Steps

- Explore the individual demo README files for specific features
- Check the main [README.md](./README.md) for detailed demo information
- Visit the [Docker AI documentation](https://docs.docker.com/ai/) for more info

## Getting Help

If you encounter issues:

1. Check the demo-specific README in each demo directory
2. Review Docker logs: `docker compose logs`
3. Ensure all prerequisites are met: `./install.sh`
4. Check Docker and Docker Compose versions

## Cleanup

To stop and remove containers:

```bash
# In a demo directory
docker compose down

# Remove volumes as well
docker compose down -v
```
