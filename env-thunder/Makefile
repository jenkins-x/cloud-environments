include ../Makefile

build: clean
	helm repo add jenkins-x $(CHART_REPO)
	helm repo update
	helm secrets dec secrets.yaml

install: clean build
	helm install jenkins-x/$(CHART) --name $(RELEASE) -f ./myvalues.yaml -f ./secrets.yaml.dec --version $(CHART_VERSION)

upgrade: clean build
	helm upgrade $(RELEASE) jenkins-x/$(CHART) -f myvalues.yaml -f secrets.yaml.dec --version $(CHART_VERSION)