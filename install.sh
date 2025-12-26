#!/bin/bash

# Installation and setup script for Compose for Agents demos
# This script checks prerequisites and helps set up the environment

set -e

echo "========================================"
echo "Compose for Agents - Installation Check"
echo "========================================"
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track if all requirements are met
ALL_REQUIREMENTS_MET=true

# Check Docker
echo "Checking Docker..."
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version | awk '{print $3}' | sed 's/,//')
    echo -e "${GREEN}✓${NC} Docker is installed: $DOCKER_VERSION"
    
    # Check if Docker daemon is running
    if docker ps &> /dev/null; then
        echo -e "${GREEN}✓${NC} Docker daemon is running"
    else
        echo -e "${RED}✗${NC} Docker daemon is not running. Please start Docker."
        ALL_REQUIREMENTS_MET=false
    fi
else
    echo -e "${RED}✗${NC} Docker is not installed"
    echo "  Please install Docker Desktop 4.43.0+ or Docker Engine"
    echo "  Visit: https://www.docker.com/products/docker-desktop/"
    ALL_REQUIREMENTS_MET=false
fi

echo ""

# Check Docker Compose
echo "Checking Docker Compose..."
if docker compose version &> /dev/null; then
    COMPOSE_VERSION=$(docker compose version | awk '{print $4}' | sed 's/v//')
    echo -e "${GREEN}✓${NC} Docker Compose is installed: $COMPOSE_VERSION"
else
    echo -e "${RED}✗${NC} Docker Compose is not installed or not compatible"
    echo "  Please install Docker Compose 2.38.1 or later"
    echo "  Visit: https://docs.docker.com/compose/install/"
    ALL_REQUIREMENTS_MET=false
fi

echo ""

# Check for GPU (optional)
echo "Checking GPU support (optional for local models)..."
if command -v nvidia-smi &> /dev/null; then
    echo -e "${GREEN}✓${NC} NVIDIA GPU detected"
    nvidia-smi --query-gpu=name --format=csv,noheader | head -1
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${GREEN}✓${NC} macOS detected - using Metal GPU acceleration"
else
    echo -e "${YELLOW}⚠${NC} No GPU detected"
    echo "  GPU is recommended for running local models"
    echo "  You can use Docker Offload as an alternative"
    echo "  Visit: https://www.docker.com/products/docker-offload/"
fi

echo ""
echo "========================================"

if [ "$ALL_REQUIREMENTS_MET" = true ]; then
    echo -e "${GREEN}✓ All requirements are met!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Choose a demo from the available demos (see README.md)"
    echo "2. Navigate to the demo directory, e.g., cd ./agno"
    echo "3. If needed, create .mcp.env file from mcp.env.example"
    echo "4. Run: docker compose up --build"
    echo ""
    echo "Or use the quick-start script:"
    echo "  ./run.sh [demo-name]"
    echo ""
    echo "Available demos: a2a, agno, vercel, crew-ai, adk, langgraph,"
    echo "                 langchaingo, spring-ai, embabel, minions,"
    echo "                 adk-cerebras, adk-sock-shop, akka"
else
    echo -e "${RED}✗ Some requirements are not met${NC}"
    echo "Please install the missing prerequisites and run this script again"
    exit 1
fi
