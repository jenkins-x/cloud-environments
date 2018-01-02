CHART_REPO := http://chartmuseum.thunder.thunder.fabric8.io
CHART := jenkins-x-platform
CHART_VERSION := 0.0.1
OS := $(shell uname)
HELM := $(shell command -v helm 2> /dev/null)
RELEASE := jenkins-x

setup:
	minikube addons enable ingress
ifndef HELM
ifeq ($(OS),Darwin)
	brew install kubernetes-helm
else
	echo "Please install helm first https://github.com/kubernetes/helm/blob/master/docs/install.md"
endif
endif
	helm init
	helm repo add jenkins-x $(CHART_REPO)

delete:
	helm delete --purge $(RELEASE)
	kubectl delete cm --all

clean:
	rm -rf secrets.yaml.dec