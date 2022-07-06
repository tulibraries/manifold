#Defaults
include .env
export #exports the .env variables

#Set DOCKER_IMAGE_VERSION in the .env file OR by passing in
VERSION ?= $(DOCKER_IMAGE_VERSION)
BASE_IMAGE ?= harbor.k8s.temple.edu/library/ruby:2.7-alpine
IMAGE ?= tulibraries/manifold
HARBOR ?= harbor.k8s.temple.edu
PLATFORM ?= linux/x86_64
CLEAR_CACHES ?= no
RAILS_MASTER_KEY ?= $(MANIFOLD_MASTER_KEY)
MANIFOLD_DB_HOST ?= host.docker.internal
MANIFOLD_DB_NAME ?= manifold
MANIFOLD_DB_USER ?= manifold

CI ?= false

DEFAULT_RUN_ARGS ?= -e "EXECJS_RUNTIME=Disabled" \
		-e "K8=yes" \
		-e "RAILS_ENV=production" \
		-e "RAILS_MASTER_KEY=$(RAILS_MASTER_KEY)" \
		-e "RAILS_SERVE_STATIC_FILES=yes" \
		-e "MANIFOLD_DB_HOST=$(MANIFOLD_DB_HOST)" \
		-e "MANIFOLD_DB_NAME=$(MANIFOLD_DB_NAME)" \
		-e "MANIFOLD_DB_PASSWORD=$(MANIFOLD_DB_PASSWORD)" \
		-e "MANIFOLD_DB_USER=$(MANIFOLD_DB_USER)" \
		-e "RAILS_LOG_TO_STDOUT=yes" \
		--rm -it

build:
	@docker build --build-arg RAILS_MASTER_KEY=$(RAILS_MASTER_KEY) \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		--platform $(PLATFORM) \
		--progress plain \
		--tag $(HARBOR)/$(IMAGE):$(VERSION) \
		--tag $(HARBOR)/$(IMAGE):latest \
		--file .docker/app/Dockerfile \
		--no-cache .

run:
	@docker run --name=manifold -p 127.0.0.1:3000:3000/tcp \
		--platform $(PLATFORM) \
		$(DEFAULT_RUN_ARGS) \
		$(HARBOR)/$(IMAGE):$(VERSION)

lint:
	@if [ $(CI) == false ]; \
		then \
			hadolint .docker/app/Dockerfile; \
		fi

shell:
	@docker run --rm -it \
		$(DEFAULT_RUN_ARGS) \
		--entrypoint=sh --user=root \
		$(HARBOR)/$(IMAGE):$(VERSION)

db-init:
	@docker run --name=manifold-db-init\
		--entrypoint=/bin/sh\
		$(DEFAULT_RUN_ARGS) \
		$(HARBOR)/$(IMAGE):$(VERSION) -c 'rails db:migrate 2>/dev/null || rails db:setup'

scan:
	@if [ $(CLEAR_CACHES) == yes ]; \
		then \
			trivy image -c $(HARBOR)/$(IMAGE):$(VERSION); \
		fi
	@if [ $(CI) == false ]; \
		then \
			trivy image $(HARBOR)/$(IMAGE):$(VERSION); \
		fi

deploy: scan lint
	@docker push $(HARBOR)/$(IMAGE):$(VERSION) \
	# This "if" statement needs to be a one liner or it will fail.
	# Do not edit indentation
	@if [ $(VERSION) != latest ]; \
		then \
			docker push $(HARBOR)/$(IMAGE):latest; \
		fi
