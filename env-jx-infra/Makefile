include ../Makefile

build: clean
	helm repo add jenkins-x $(CHART_REPO)
	helm repo update
	helm secrets dec secrets.yaml

install: clean build
	helm secrets dec secrets.yaml
	helm install jenkins-x/$(CHART) --name $(RELEASE) -f ./myvalues.yaml -f ./secrets.yaml.dec --version $(CHART_VERSION) $(ARGS)

upgrade: clean build
	helm secrets dec secrets.yaml
	helm upgrade $(RELEASE) jenkins-x/$(CHART) -f myvalues.yaml -f secrets.yaml.dec --version $(CHART_VERSION) $(ARGS)