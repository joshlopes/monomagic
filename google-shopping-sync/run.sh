#!/usr/bin/env bash

# Check if we're running in Home Assistant Add-on environment
if command -v bashio > /dev/null 2>&1; then
    # Running as Home Assistant Add-on
    echo "Running as Home Assistant Add-on"

    # Get config values from Home Assistant
    GOOGLE_EMAIL=$(bashio::config 'GOOGLE_EMAIL')
    GOOGLE_APP_PASSWORD=$(bashio::config 'GOOGLE_APP_PASSWORD')
    SYNC_INTERVAL=$(bashio::config 'SYNC_INTERVAL')

    # Set Home Assistant URL and token automatically
    HA_URL="http://supervisor/core"
    HA_TOKEN=$(bashio::supervisor.token)

    # Print info using bashio
    bashio::log.info "Starting Google Keep to HA Shopping List Sync..."
    bashio::log.info "Google Account: ${GOOGLE_EMAIL}"
    bashio::log.info "Sync Interval: ${SYNC_INTERVAL} seconds"
else
    # Running as standalone Docker container
    echo "Running as standalone Docker container"

    # Environment variables should already be set via docker run --env-file
    echo "Starting Google Keep to HA Shopping List Sync..."
    echo "Google Account: ${GOOGLE_EMAIL}"
    echo "Sync Interval: ${SYNC_INTERVAL:-300} seconds"
fi

# Export as environment variables
export GOOGLE_EMAIL
export GOOGLE_APP_PASSWORD
export HA_URL
export HA_TOKEN
export SYNC_INTERVAL

# Run the sync script
python3 /app/index.py
