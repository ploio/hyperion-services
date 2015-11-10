# Copyright (C) 2014, 2015 Nicolas Lamirault <nicolas.lamirault@gmail.com>

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

APP = hyperion-services
VERSION = 0.1.0

SHELL := /bin/bash

VAGRANT = vagrant
DOCKER = "docker"

K8S_URI=https://storage.googleapis.com/kubernetes-release/release
K8S_VERSION=1.1.1
K8S_ARCH=linux/amd64
K8S_BINARIES = \
	kube-apiserver \
	kube-proxy \
	kube-scheduler \
	kube-controller-manager \
	kubelet \
	kubectl

NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

OUTPUT=`pwd`

all: help

help:
	@echo -e "$(OK_COLOR) ==== [$(APP)] [$(VERSION)]====$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)- init$(NO_COLOR)   : Initialize environment$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)- start$(NO_COLOR)  : Start the Kubernetes cluster(NO_COLOR)"
	@echo -e "$(WARN_COLOR)- stop$(NO_COLOR)   : Stop the Kubernetes cluster(NO_COLOR)"
	@echo -e "$(WARN_COLOR)- status$(NO_COLOR) : Status of the Kubernetes cluster(NO_COLOR)"

clean:
	rm -fr output hyperion-*.tar.gz

.PHONY: k8s
k8s: configure
	@echo -e "$(OK_COLOR)[$(APP)] Download Kubernetes$(NO_COLOR)"
	for i in $(K8S_BINARIES); do \
		curl --silent -o $(OUTPUT)/$$i -L ${K8S_URI}/v${K8S_VERSION}/bin/$(K8S_ARCH)/$$i; \
		chmod +x $(OUTPUT)/$$i; \
	done

.PHONY: init
init: k8s

.PHONY: stop
stop:
	@echo -e "$(OK_COLOR)[$(APP)] Stop Kubernetes$(NO_COLOR)"
	@kubectl stop replicationcontrollers,services,pods --all
	@docker-compose stop
	@docker-compose rm -f -v

.PHONY: start
start:
	@echo -e "$(OK_COLOR)[$(APP)] Start Kubernetes$(NO_COLOR)"
	@docker-compose up -d
	@docker-compose ps

.PHONY: status
status:
	@echo -e "$(OK_COLOR)[$(APP)] Status of Kubernetes$(NO_COLOR)"
	@docker-compose ps
