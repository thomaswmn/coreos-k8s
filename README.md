# README
## Concept

This setup is based on Fedora CoreOS - https://getfedora.org/en/coreos. CoreOS 
comes with the ability to execute containers via Docker and Podman. However, it
naturally does not come with Kubernetes. Here, we configure CoreOS such that it 
becomes a Kubernetes cluster after boot.

The setup consist of a CoreOS disk image, where some additional files are 
injected, and an Iginition config file. Among the files injected into the CoreOS
image are the ontainer images required to start up the Kubernetes cluster. 

This git repo contains a collection of scripts required to download the 
relevant blobs from the Internet, and to configure all pieces to fit together.

The setup currently creates a single-node Kubernetes cluster, only. Adding 
further nodes is planned, based on a simplified version of the config used for
the master node. Further, the setup currently runs on a Qemu VM. Extension to
an OpenStack cluster is planned.

The overall system adheres to the following design principles.


### Design Principles
* Stateless - the setup does not preserve any state across reboots.  
  All configuration is loaded at boot time via the CoreOS Ignition mechanism.
  On each reboot, the cluster looks the same. In case of a miss-configuration,
  just reboot.

* Offline - the setup is intended to run without Internet connectivity.  
  Downloading the same Docker images from an external registry at every startup
  of the system unnecessarily loades the Internet link. Providing Internet 
  connectivity might complicate a typical test setup. In many company networks, 
  direct Internet connectivity is not available everywhere. However, Internet
  connectivity is required to prepare the environment, e.g. on a dev computer.
 
## Overview of Repo Content

The main config file is example.fcc, which is the template for the Ignition 
file used to configure the system at boot. All additions and modifications made
to the CoreOS system during boot are defined in this file.

In addition, the repo contains the scripts and directories introduced in the 
following paragraphs.

### Directories
* bin - for tools required to prepare the environment
* blob - blobs ownloaded from the internet, also the modified CoreOS qcow image
* deployments - k8s deployment yaml files, generated from deployments-builder
* deployments-builder - environment to create deployment yaml files (e.g. from
  templates)
* qcow-image-builder - resources to inject files into the qcow disk image 
* target-scripts - scripts that get linked to /usr/local/bin
* tls - to manage various keys and certificates required for the system

### Scripts
The scripts used to prepare the environment are intended to be executed on a 
developer system, maybe later as part of a CI/CD environment. The scripts are
named by numbers. These numbers denote a loose grouping and ordering.
* 0... denotes scripts required to prepare the environment on the dev system.
  These highly depend on the development environment.
* 1... denotes scripts executed regularly, to prepare the config and test it.
* 5... denotes scripts execured infrequently, to download and prepare blobs.

### Detailed Explanation of Scripts
* 01_start-docker.sh - start the systemd docker.service on my dev computer
* 02_init-bridge.sh - initialize the network on my dev computer

* 10_compile_ignition.sh - take the input ".fcc" file, some input from the tls
  directory, and compile the Ignition configuration file that is finally loaded
  on boot of the system
* 11_prepare_qcow_image.sh - patch qcow imgage to contain all required data
* 12_run_qemu.sh - start the qemu VM to test the setup

* 51_download_coreos_image.sh - download the latest stable CoreOS image
* 52_download_docker_images.sh - download the required container images and 
  create the disk image that is used by the final system to load the images. 
  Makes use of the tooling in the directory image-builder.
* 53_download_tools.sh - download mo (and maybe other tools), required for 
  image preparation

### Certificates

Scripts for certificate generation are stored below tls/. These have to be
executed before the ignition file can be compiled. For further information,
check the scripts used to generate the certificates, and the places where
they are referenced.

## TODOs
This is an experimental test setup, mostly intended to check whether this is 
feasible. There was no intention yet to make the system stable, reliable, 
secure, or similar.

Actual list of TODOs, where I collect things I plan to do
* admission controller SecurityContextDeny is disabled here, but might be 
  better to re-enable it
* define a clear concept which configs to hard-code in the fcc file and which 
  to insert via mo
* same for config files - could use directory with configs instead of inlining 
  them in the examle.fcc
* and many others

## External Tools Used

This product relies on many different packages of software developed by 
contributors. 

* CoreOS
* Kubernetes, etcd, Kubernetes-Dashboard
* Docker
* Openssl
* guestfish
* The template rendering engine "mo" is used to replace variables inside the 
  configuration file, before compiling the Ignition file.
