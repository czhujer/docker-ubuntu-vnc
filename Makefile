
.PHONY: podman-run
podman-run:
	podman \
		run \
		-v ~/.kube:/root/.kube \
		-v ~/.azure:/root/.azure \
		--rm \
		--name ubuntu-vnc \
		-ti \
		-p 6080:6080 \
		localhost/amd64/ubuntu-vnc \
		bash

# 	podman manifest create ubuntu-vnc

podman-build:
	podman \
		build \
		--platform linux/amd64 \
		--security-opt label=disable \
		-t localhost/amd64/ubuntu-vnc:latest \
		.
