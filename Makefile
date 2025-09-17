MARIADB_VERSION:=10.6.19
DOCKER_IMAGE_NAME:=florinbuzec/mysql-src-h
DOCKER_IMAGE_TAG:=mariadb-10.6.19
DOCKER_IMAGE_FULL:=${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}
DOCKER_IMAGE_FULL2:=${DOCKER_IMAGE_NAME}:mariadb-11.8.1
export DOCKER_IMAGE_FULL
export DOCKER_IMAGE_FULL2

.PHONY: help
help: ## View all make targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: check
check:
	@if [ -z "$${DOCKER_IMAGE_FULL}" ]; then \
		echo "Please configure the .env file with required variables."; \
		exit 1; \
	fi

.PHONY: build
build: check ## Build the image
	docker build . \
		--build-arg MARIADB_VERSION=${MARIADB_VERSION} \
		-t ${DOCKER_IMAGE_FULL} \
		-t ${DOCKER_IMAGE_FULL2}

.PHONY: dockerhub-login
dockerhub-login:
	@set -a; \
	. ./.env; \
	set +a; \
	if [ -z "$${DOCKERHUB_LOGIN}" ]; then \
		echo "Please configure the .env file with required variables."; \
		exit 1; \
	fi; \
	echo "$$DOCKERHUB_TOKEN" | docker login -u "$$DOCKERHUB_LOGIN" --password-stdin

.PHONY: push
push: dockerhub-login check ## Push the builded image to the registry
	@docker push ${DOCKER_IMAGE_FULL}
	@docker push ${DOCKER_IMAGE_FULL2}
