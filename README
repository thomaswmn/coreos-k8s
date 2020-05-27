# README
## Concept

This setup is based on Fedora CoreOS - https://getfedora.org/en/coreos. CoreOS 
comes with the ability to execute containers via Docker and Podman. However, it
naturally does not come with Kubernetes. Here, we configure CoreOS such that it 
becomes a Kubernetes cluster after boot.

The setup consist of an unmodified CoreOS image, an Iginition config file, and
a second disk image holding all the container images required to start up the
Kubernetes cluster. In addition, this git repo contains a collection of scripts
required to download the relevant blobs from the Internet, and to configure all
pieces to fit together.

The setup currently creates a single-node Kubernetes cluster, only. Adding 
further nodes is planned, based on a simplified version of the config used for
the master node. Further, the setup currently runs on a Qemu VM. Extension to
an OpenStack cluster is planned.

The overall system adheres to the following design principles.


### Design Principles
* Stateless - the setup does not preserve any state across reboots. 
  All configuration is loaded at boot time via the CoreOS Ignition mechanism.
  On each reboot, the cluster looks the same. In case of a miss-configuration,
  just reboot!

* Offline - the setup is intended to run without Internet connectivity.
  Downloading the same Docker images from an external registry at every startup
  of the system unnecessarily loades the Internet link. Providing Internet 
  connectivity might complicate a typical test setup. In many company networks, 
  direct Internet connectivity is not available everywhere. 
 

## TODOs
This is an experimental test setup, mostly intended to check whether this is 
feasible. There was no intention yet to make the system stable, reliable, 
secure, or similar.

Actual list of TODOs, where I collect things I plan to do
* create service account private / public key pair on boot of master
* create other CA and keys on boot of master
* admission controller SecurityContextDeny is disabled here, but might be 
  better to re-enable it
* define a clear concept which configs to hard-code in the fcc file and which 
  to insert via mo
* same for config files - could use directory with configs instead of inlining 
  them in the examle.fcc
* and many others
