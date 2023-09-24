
# host environment
HOST = pi@192.168.178.31
HOST_DIR = ~/sensor-project
HOST_SERVICE_DIR = /etc/systemd/system

# Project
SERVICE_NAME = bme280.service
SCRIPT_NAME = main.py

# Local Environment
LOCAL_SRC_DIR = ./src
LOCAL_SSH_DIR = ~/.ssh/id_rsa.pub
LOCAL_SERVICE_PATH = ./src/$(SERVICE_NAME)



help: ## show all make scripts
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

ssh-install: ## install ssh on the HOST
	# -ssh-keygen -f $(LOCAL_KNOWN_HOSTS) -R $(HOST) #comment this out if you want to generate new key instead of using the current
	-ssh-copy-id -i $(LOCAL_SSH_DIR) $(HOST)

remote: ## get the ssh pash of the HOST
	ssh $(HOST)

sync:  ## sync to the HOST, enforce ssh authentication example
	rsync \
	--verbose \
	--archive \
	--recursive \
	--delete-during \
	--delete-excluded \
	--exclude=Python-API \
	--exclude=Makefile \
	--exclude=/.git/ \
	--exclude=/.github/ \
	--exclude=*.gitignore \
	--exclude=/.vscode/ \
	-e 'ssh -p 22' \
	$(LOCAL_SRC_DIR) \
	$(HOST):$(HOST_DIR)

run:  ## runs the script on the pi
	ssh -t $(HOST) " \
		/usr/bin/python3 $(HOST_DIR)/$(SCRIPT_NAME) \
		" \

service-status:  ## restart the service after changes have been uploaded
	ssh -t $(HOST) "sudo systemctl status $(SERVICE_NAME)"

service-restart:  ## restart the service after changes have been uploaded
	ssh -t $(HOST) "sudo systemctl restart $(SERVICE_NAME)"

service-stop:  ## restart the service after changes have been uploaded
	ssh -t $(HOST) "sudo systemctl restart $(SERVICE_NAME)"

service-up: ## moves the service file to the directory on the debian and registers the service
	rsync \
	--verbose \
	--archive \
	--delete-during \
	-e 'ssh -p 22' \
	$(LOCAL_SERVICE_PATH) \
	$(HOST):$(HOST_SERVICE_DIR)

	ssh -t $(HOST) " \
		&& sudo chmod 644 $(HOST_SERVICE_DIR)/$(SERVICE_NAME) \
		&& sudo chmod 644 $(HOST_DIR)/$(SCRIPT_NAME) \
		&& sudo systemctl enable $(SERVICE_NAME) \
		&& sudo systemctl daemon-reload \
		&& sudo systemctl start $(SERVICE_NAME)"

