ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.15
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install requirements
RUN apk add --no-cache python3 py3-pip gcc musl-dev python3-dev

# Copy data
COPY . /app

# Set working directory
WORKDIR /app

# Install Python requirements
RUN pip3 install --no-cache-dir -r requirements.txt

# Make run script executable
RUN chmod a+x /app/run.sh

CMD [ "/app/run.sh" ]
