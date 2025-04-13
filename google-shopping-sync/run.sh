#!/usr/bin/env bash

# Check if we're running in Home Assistant Add-on environment
if command -v bashio > /dev/null 2>&1; then
    # Running as Home Assistant Add-on
    echo "Running as Home Assistant Add-on"

    # Try to get config values from Home Assistant
    # If any command fails, fall back to environment variables
    if bashio::config.exists 'GOOGLE_EMAIL' && bashio::config.exists 'GOOGLE_APP_PASSWORD'; then
        GOOGLE_EMAIL=$(bashio::config 'GOOGLE_EMAIL')
        GOOGLE_APP_PASSWORD=$(bashio::config 'GOOGLE_APP_PASSWORD')
        SYNC_INTERVAL=$(bashio::config 'SYNC_INTERVAL' '300')

        # Set Home Assistant URL and token automatically if possible
        if bashio::supervisor.ping; then
            HA_URL="http://supervisor/core"
            HA_TOKEN=$(bashio::supervisor.token)
        fi

        # Print info using bashio
        bashio::log.info "Starting Google Keep to HA Shopping List Sync..."
        bashio::log.info "Google Account: ${GOOGLE_EMAIL}"
        bashio::log.info "Sync Interval: ${SYNC_INTERVAL} seconds"
    else
        echo "Bashio detected but couldn't get config values, falling back to environment variables"
    fi
else
    # Running as standalone Docker container
    echo "Running as standalone Docker container"

    # Environment variables should already be set via docker run --env-file
    echo "Starting Google Keep to HA Shopping List Sync..."
    echo "Google Account: ${GOOGLE_EMAIL}"
    echo "Sync Interval: ${SYNC_INTERVAL:-300} seconds"
fi

# Make sure we have default values for required variables
GOOGLE_EMAIL=${GOOGLE_EMAIL:-""}
GOOGLE_APP_PASSWORD=${GOOGLE_APP_PASSWORD:-""}
HA_URL=${HA_URL:-"http://supervisor/core"}
HA_TOKEN=${HA_TOKEN:-""}
SYNC_INTERVAL=${SYNC_INTERVAL:-300}

# Export as environment variables
export GOOGLE_EMAIL
export GOOGLE_APP_PASSWORD
export HA_URL
export HA_TOKEN
export SYNC_INTERVAL

# Check if required variables are set
if [ -z "$GOOGLE_EMAIL" ] || [ -z "$GOOGLE_APP_PASSWORD" ] || [ -z "$HA_TOKEN" ]; then
    echo "ERROR: Required environment variables are not set!"
    echo "Please make sure GOOGLE_EMAIL, GOOGLE_APP_PASSWORD, and HA_TOKEN are set."
    echo "See the README.md file for more information."
    exit 1
fi

# Run the sync script
python3 /app/index.py
