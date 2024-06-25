
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
		ubuntu-vnc \
		bash

# 	podman manifest create ubuntu-vnc

podman-build:
	podman \
		build \
		--platform linux/amd64,linux/arm64 \
		--security-opt label=disable \
		--manifest ubuntu-vnc \
		.
