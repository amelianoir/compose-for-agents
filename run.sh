#!/bin/bash

# Quick start script for Compose for Agents demos
# Usage: ./run.sh [demo-name] [options]

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Available demos
DEMOS=("a2a" "agno" "vercel" "crew-ai" "adk" "langgraph" "langchaingo" "spring-ai" "embabel" "minions" "adk-cerebras" "adk-sock-shop" "akka")

# Function to display usage
show_usage() {
    echo "Usage: ./run.sh [demo-name] [options]"
    echo ""
    echo "Available demos:"
    for demo in "${DEMOS[@]}"; do
        echo "  - $demo"
    done
    echo ""
    echo "Options:"
    echo "  --openai    Use OpenAI models (requires secret.openai-api-key file)"
    echo "  --detach    Run in detached mode"
    echo ""
    echo "Examples:"
    echo "  ./run.sh agno"
    echo "  ./run.sh vercel --detach"
    echo "  ./run.sh adk --openai"
    echo ""
    echo "If no demo is specified, the script will show this help message."
}

# Function to check if demo exists
check_demo_exists() {
    local demo=$1
    if [[ ! -d "./$demo" ]]; then
        echo -e "${RED}Error: Demo '$demo' not found${NC}"
        echo ""
        show_usage
        exit 1
    fi
}

# Function to check for MCP configuration
check_mcp_config() {
    local demo=$1
    if [[ -f "./$demo/mcp.env.example" && ! -f "./$demo/.mcp.env" ]]; then
        echo -e "${YELLOW}⚠ Warning: This demo has an mcp.env.example file${NC}"
        echo "You may need to create a .mcp.env file with your API keys."
        echo ""
        echo "Example:"
        echo "  cp ./$demo/mcp.env.example ./$demo/.mcp.env"
        echo "  # Then edit ./$demo/.mcp.env with your API keys"
        echo ""
        read -p "Continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Main script
echo -e "${BLUE}========================================"
echo "Compose for Agents - Quick Start"
echo -e "========================================${NC}"
echo ""

# Check if no arguments provided or help flag
if [ $# -eq 0 ]; then
    show_usage
    exit 0
fi

# Check for help flag first
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_usage
    exit 0
fi

# Parse demo name
DEMO=$1
shift

# Parse options
USE_OPENAI=false
DETACHED=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --openai)
            USE_OPENAI=true
            shift
            ;;
        --detach|-d)
            DETACHED=true
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            show_usage
            exit 1
            ;;
    esac
done

# Validate demo exists
check_demo_exists "$DEMO"

# Check MCP configuration
check_mcp_config "$DEMO"

# Change to demo directory
cd "./$DEMO"

# Prepare compose command as array (--build is the default per README)
COMPOSE_CMD=(docker compose -f compose.yaml)

# Add OpenAI compose file if requested
if [ "$USE_OPENAI" = true ]; then
    if [[ -f "compose.openai.yaml" ]]; then
        echo -e "${GREEN}✓${NC} Using OpenAI models"
        COMPOSE_CMD+=(-f compose.openai.yaml)
        
        # Check for OpenAI API key
        if [[ ! -f "secret.openai-api-key" ]]; then
            echo -e "${YELLOW}⚠ Warning: secret.openai-api-key file not found${NC}"
            echo "Create this file with your OpenAI API key to use OpenAI models"
            echo ""
            read -p "Continue anyway? (y/N) " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                exit 1
            fi
        fi
    else
        echo -e "${YELLOW}⚠ Warning: This demo doesn't have OpenAI support${NC}"
    fi
fi

# Always use --build as recommended in README
COMPOSE_CMD+=(up --build)

# Add detached flag if requested
if [ "$DETACHED" = true ]; then
    COMPOSE_CMD+=(-d)
fi

echo ""
echo -e "${GREEN}Starting demo: $DEMO${NC}"
echo "Command: ${COMPOSE_CMD[*]}"
echo ""
echo "Press Ctrl+C to stop the demo"
echo ""

# Run docker compose
"${COMPOSE_CMD[@]}"

if [ "$DETACHED" = true ]; then
    echo ""
    echo -e "${GREEN}✓ Demo is running in detached mode${NC}"
    echo ""
    echo "To view logs: docker compose logs -f"
    echo "To stop: docker compose down"
fi
