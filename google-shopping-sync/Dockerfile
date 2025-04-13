ARG BUILD_FROM
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install requirements
RUN apk add --no-cache python3 py3-pip gcc musl-dev python3-dev jq curl bash

# Copy data
COPY . /app

# Set working directory
WORKDIR /app

# Install Python requirements
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir -r requirements.txt

# Make run script executable
RUN chmod a+x /app/run.sh

CMD [ "/app/run.sh" ]
