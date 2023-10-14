# Host environment
HOST = pi@192.168.178.48
HOST_DIR = ~/sensor-bme280
HOST_SERVICE_DIR = /etc/systemd/system

# Project
SERVICE_NAME = bme280.service
SCRIPT_NAME = main.py

# Local Environment
LOCAL_SRC_DIR = ./src
LOCAL_SSH_DIR = ~/.ssh/id_ed25519.pub
LOCAL_SERVICE_PATH = ./$(SERVICE_NAME)



help: ## show all make scripts
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

ssh-install: ## install ssh on the HOST
	# -ssh-keygen -f $(LOCAL_KNOWN_HOSTS) -R $(HOST) #comment this in if you want to generate new key instead of using the current
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
	--exclude=__pycache__ \
	-e 'ssh -p 22' \
	$(LOCAL_SRC_DIR)/ \
	$(HOST):$(HOST_DIR)

run:  ## runs the script on the pi
	ssh -t $(HOST) " \
		/usr/bin/python3 $(HOST_DIR)/$(SCRIPT_NAME) \
		" \

sync-run: sync run ##

service-status:  ## restart the service after changes have been uploaded
	ssh -t $(HOST) "sudo systemctl status $(SERVICE_NAME)"

service-restart:  ## restart the service after changes have been uploaded
	ssh -t $(HOST) "sudo systemctl restart $(SERVICE_NAME)"

sync-restart: sync service-restart ##

service-stop:  ## stop the service after changes have been uploaded
	ssh -t $(HOST) "sudo systemctl stop $(SERVICE_NAME)"

service-up: ## moves the service file to the directory on the debian and registers the service
	rsync \
	--verbose \
	--archive \
	--delete-during \
	--delete-excluded \
	--exclude=__pycache__ \
	--rsync-path="sudo rsync" \
	-e 'ssh -p 22' \
	$(LOCAL_SERVICE_PATH) \
	$(HOST):$(HOST_SERVICE_DIR)

	ssh -t $(HOST) " \
		sudo chmod 644 $(HOST_SERVICE_DIR)/$(SERVICE_NAME) \
		&& sudo chmod 644 $(HOST_DIR)/$(SCRIPT_NAME) \
		&& sudo systemctl enable $(SERVICE_NAME) \
		&& sudo systemctl daemon-reload \
		&& sudo systemctl start $(SERVICE_NAME)"

