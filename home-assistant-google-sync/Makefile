IMAGE_NAME = google-keep-ha-sync
CONTAINER_NAME = google-keep-ha-sync
ENV_FILE = .env

.PHONY: build run stop restart logs setup-local run-local

build:
	docker build -t $(IMAGE_NAME) .

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
