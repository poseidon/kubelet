VERSION=$(shell git describe --tags --match=v* --always --abbrev=0 --dirty)
LOCAL_REPO?=dghubble/kubelet
IMAGE_REPO?=quay.io/dghubble/kubelet

all: image

.PHONY: run
run:
	podman run -it \
		--entrypoint /bin/sh \
		dghubble/kubelet

.PHONY: image
image:
	buildah bud -t $(LOCAL_REPO):$(VERSION) .
	buildah tag $(LOCAL_REPO):$(VERSION) $(LOCAL_REPO):latest

.PHONY: push
push:
	buildah tag $(LOCAL_REPO):$(VERSION) $(IMAGE_REPO):$(VERSION)
	buildah tag $(LOCAL_REPO):$(VERSION) $(IMAGE_REPO):latest
	buildah push docker://$(IMAGE_REPO):$(VERSION)
	buildah push docker://$(IMAGE_REPO):latest

