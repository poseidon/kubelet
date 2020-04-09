FROM alpine:3.11 AS fetcher
LABEL maintainer="Dalton Hubble <dghubble@gmail.com>"

ARG KUBELET=v1.18.1
ARG ARCH=amd64
ARG SHA=88a9b68c8cba77fe50751d998117ab632d1e8aa12a45f6bef71a24ee5a8fb6f559d00f129b8682f9d5838671edb6649e3c9caebdf9ce2a37f282f21316a522e0

RUN apk add curl && \
  curl -L https://dl.k8s.io/${KUBELET}/kubernetes-node-linux-${ARCH}.tar.gz -o node.tar.gz && \
  echo "${SHA}  node.tar.gz" | sha512sum -c && \
  tar xzf node.tar.gz kubernetes/node/bin/kubectl kubernetes/node/bin/kubelet


FROM k8s.gcr.io/debian-iptables:v12.0.1
LABEL maintainer="Dalton Hubble <dghubble@gmail.com>"

RUN clean-install \
  bash \
  ca-certificates \
  ceph-common \
  cifs-utils \
  e2fsprogs \
  xfsprogs \
  ethtool \
  glusterfs-client \
  iproute2 \
  jq \
  nfs-common \
  socat \
  udev \
  util-linux

COPY --from=fetcher /kubernetes/node/bin/kubelet /usr/local/bin/kubelet
COPY --from=fetcher /kubernetes/node/bin/kubectl /usr/local/bin/kubectl
ENTRYPOINT ["/usr/local/bin/kubelet"]
