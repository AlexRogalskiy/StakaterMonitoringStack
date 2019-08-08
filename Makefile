.ONESHELL:
SHELL := /bin/bash
NAMESPACE ?= monitoring
FOLDER_NAME ?= manifests
PROVIDER_NAME ?= aws

install:
	kubectl create namespace $(NAMESPACE)
	cd $(FOLDER_NAME)
	kubectl apply -f . -n $(NAMESPACE)
	cd grafanaDashboards/
	kubectl apply -f . -n $(NAMESPACE)

install-dry-run:
	cd $(FOLDER_NAME)
	kubectl apply -f . -n $(NAMESPACE) --dry-run
	cd grafanaDashboards/
	kubectl apply -f . -n $(NAMESPACE) --dry-run

delete:
	cd $(FOLDER_NAME)
	kubectl delete -f . -n $(NAMESPACE)
	cd grafanaDashboards/
	kubectl delete -f . -n $(NAMESPACE)
