IMAGE_NAME = google-keep-ha-sync
CONTAINER_NAME = google-keep-ha-sync
ENV_FILE = .env
ARCH ?= amd64
BUILD_ARG ?=
# GitHub Container Registry credentials (optional)
GH_USERNAME ?=
GH_TOKEN ?=

build:
	@echo "Building Docker image for $(ARCH) architecture..."
	@BUILD_FROM=$$(jq -r '.build_from.$(ARCH)' build.json) && \
	echo "Using base image: $$BUILD_FROM" && \
	if [ -n "$(GH_USERNAME)" ] && [ -n "$(GH_TOKEN)" ]; then \
		echo "Logging in to GitHub Container Registry..." && \
		echo $(GH_TOKEN) | docker login ghcr.io -u $(GH_USERNAME) --password-stdin; \
	fi && \
	docker build \
		--build-arg BUILD_FROM=$$BUILD_FROM \
		$(BUILD_ARG) \
		-t $(IMAGE_NAME) .

run:
	docker run --rm \
		--name $(CONTAINER_NAME) \
		--env-file $(ENV_FILE) \
		$(IMAGE_NAME)

stop:
	docker stop $(CONTAINER_NAME) || true

restart: stop run

logs:
	docker logs -f $(CONTAINER_NAME)

# Local development targets
setup-local:
	chmod +x setup_local.sh
	./setup_local.sh

run-local:
	@echo "Activating virtual environment and running application..."
	@if [ -d "venv" ]; then \
		source venv/bin/activate && python index.py; \
	else \
		echo "Virtual environment not found. Run 'make setup-local' first."; \
	fi
