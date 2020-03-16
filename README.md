# Kubelet

`kubelet` provides a [container image](https://quay.io/repository/poseidon/kubelet) packaging the upstream Kubernetes `kubelet` and dependencies, for use on container-optimized OS distributions.

`kubelet` is a low-level component of the [Typhoon](https://github.com/poseidon/typhoon) Kubernetes distribution.

## Packages

The [debian-iptables](https://github.com/kubernetes/kubernetes/tree/master/build/debian-iptables) base provides `conntrack`, `ebtables`, `ipset`, `kmod`, and `netbase`.

Kubelet also requires:

* `ca-certificates` - https://github.com/kubernetes/kubernetes/pull/7755
* `ceph-common` - https://github.com/kubernetes/kubernetes/pull/34416
* `cifs-utils` - https://github.com/kubernetes/kubernetes/pull/34416
* `e2fsprogs` (`mkfs.ext4`) - https://github.com/kubernetes/kubernetes/issues/52789
* `xfsprogs` - https://github.com/kubernetes/kubernetes/pull/56937
* `ethtool` - https://github.com/kubernetes/kubernetes/pull/18273
* `glusterfs-client` - https://github.com/kubernetes/kubernetes/pull/32686
* `jq` - https://github.com/coreos/bugs/issues/1706
* `kmod` (`modprobe`) - https://github.com/kubernetes/kubernetes/pull/53642
* `nfs-common` - https://github.com/kubernetes/kubernetes/pull/30320
* `udev` (`udevadm`)- https://github.com/kubernetes/kubernetes/pull/61357

The following are only required for gitRepo Volumes (deprecated):

* `git` - https://github.com/kubernetes/kubernetes/pull/23407
* `openssh-client` - https://github.com/kubernetes/kubernetes/pull/54250

### kubectl

`kubectl` (no dependencies) is also included for convenience (e.g. use already pulled Kubelet image to `kubectl delete node` on preemption)

