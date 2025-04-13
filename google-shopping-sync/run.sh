#!/usr/bin/with-contenv bashio

# Get config values
GOOGLE_EMAIL=$(bashio::config 'GOOGLE_EMAIL')
GOOGLE_APP_PASSWORD=$(bashio::config 'GOOGLE_APP_PASSWORD')
SYNC_INTERVAL=$(bashio::config 'SYNC_INTERVAL')

# Set Home Assistant URL and token automatically
HA_URL="http://supervisor/core"
HA_TOKEN=$(bashio::supervisor.token)

# Export as environment variables
export GOOGLE_EMAIL
export GOOGLE_APP_PASSWORD
export HA_URL
export HA_TOKEN
export SYNC_INTERVAL

# Print info
bashio::log.info "Starting Google Keep to HA Shopping List Sync..."
bashio::log.info "Google Account: ${GOOGLE_EMAIL}"
bashio::log.info "Sync Interval: ${SYNC_INTERVAL} seconds"

# Run the sync script
python3 /app/index.py
