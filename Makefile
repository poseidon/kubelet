VERSION=$(shell git describe --tags --match=v* --always --dirty)

LOCAL_REPO?=poseidon/kubelet
IMAGE_REPO?=quay.io/poseidon/kubelet

image: \
	image-amd64 \
	image-arm64

image-%:
	buildah bud -f Dockerfile.$* \
		-t $(LOCAL_REPO):$(VERSION)-$* \
		--arch $* --override-arch $* \
		--format=docker .

