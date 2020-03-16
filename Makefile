VERSION=$(shell git describe --tags --match=v* --always --abbrev=0 --dirty)
LOCAL_REPO?=dghubble/kubelet
IMAGE_REPO?=quay.io/dghubble/kubelet

KUBELET?=v1.17.4
ARCH?=amd64
SHA=31cfbc4610504a02c7b3fcd0b97b48b27afdf9232fa0d02527c7873a78bb72f9f3c8fac77a2187695da5cfd40f4d42691d188fa142da3d3b7807e034a279d477

all: image

.PHONY: run
run:
	podman run -it \
		--entrypoint /bin/sh \
		dghubble/kubelet

.PHONY: image
image:
	buildah bud -t $(LOCAL_REPO):$(VERSION) \
		--build-arg KUBELET=$(KUBELET) \
		--build-arg ARCH=$(ARCH) \
		--build-arg SHA=$(SHA) .
	buildah tag $(LOCAL_REPO):$(VERSION) $(LOCAL_REPO):latest

.PHONY: push
push:
	buildah tag $(LOCAL_REPO):$(VERSION) $(IMAGE_REPO):$(VERSION)
	buildah tag $(LOCAL_REPO):$(VERSION) $(IMAGE_REPO):latest
	buildah push docker://$(IMAGE_REPO):$(VERSION)
	buildah push docker://$(IMAGE_REPO):latest

