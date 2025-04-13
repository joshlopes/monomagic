ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.15
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install requirements
RUN apk add --no-cache python3 py3-pip gcc musl-dev python3-dev jq curl bash

# Install bashio for Home Assistant Add-on support if it's not already installed
RUN if ! command -v bashio > /dev/null 2>&1; then \
      echo "Installing bashio..." \
      && curl -J -L -o /tmp/bashio.tar.gz "https://github.com/hassio-addons/bashio/archive/v0.15.0.tar.gz" \
      && mkdir -p /tmp/bashio \
      && tar zxvf /tmp/bashio.tar.gz --strip 1 -C /tmp/bashio \
      && mkdir -p /usr/lib/bashio \
      && cp -R /tmp/bashio/lib/* /usr/lib/bashio/ \
      && ln -sf /usr/lib/bashio/bashio /usr/bin/bashio \
      && rm -rf /tmp/bashio*; \
    else \
      echo "Bashio is already installed"; \
    fi

# Copy data
COPY . /app

# Set working directory
WORKDIR /app

# Install Python requirements
RUN pip3 install --no-cache-dir -r requirements.txt

# Make run script executable
RUN chmod a+x /app/run.sh

CMD [ "/app/run.sh" ]
