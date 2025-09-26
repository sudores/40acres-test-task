# Minikube + Terraform + ArgoCD Setup

This repository provides a simple setup to run a local Kubernetes cluster with Minikube, deploy ArgoCD via Terraform, and bootstrap applications including Bitcoin and Prometheus. The goal is simplicity and reproducibility.

---

## Prerequisites

* Docker installed and running
* Minikube installed
* Terraform installed (v1.5+ recommended)
* `kubectl` installed
* Access to modify `/etc/hosts` for local ingress resolution

---

## Step 1: Start Minikube

Start a Minikube cluster with a specific Kubernetes version and container runtime:

```bash
minikube start --kubernetes-version=v1.32.8 --driver=docker --container-runtime=containerd
```

> This will also automatically update your `kubectl` context to point to the Minikube cluster.

---

## Step 2: Initialize Terraform

Initialize Terraform in the repository:

```bash
terraform init
```

---

## Step 3: Apply Terraform Configuration

Deploy ArgoCD and the root application:

```bash
terraform apply
```

> Terraform bootstraps a minimal ArgoCD application which then pulls all other applications from a public Git repository. This uses the Applications pattern for seamless management of multiple apps.

---

## Step 4: Add Local Ingress Entries

For local access to ingresses, add the Minikube IP to your `/etc/hosts`:

```bash
echo "$(minikube ip) monitoring.gzttk.loc"  | sudo tee -a /etc/hosts
```

---

## Step 5: Explore Applications

* **Bitcoin**: Check the `bitcoin` namespace.
* **Prometheus**: Check the `monitoring` namespace. Available at monitoring.gzttk.org

---

## Notes

* This setup is primarily for simplicity and local development.
* Applications are deployed via Helm charts. PodMonitors and other monitoring resources are managed automatically.
* The Bitcoin Helm chart was created due to lack of support of testnet in present one
* Multi-environment support is not implemented yet but could be added by merging multiple values files if needed.
* Minikube left as separate step, so we assume kubernetes cluster is either managed in cloud by terraform or we have it already

---

## How It Works

1. Terraform deploys ArgoCD with a small bootstrap app to pull in all other
2. ArgoCD pulls applications from a Git repository (public for simplicity).
3. Helm charts handle individual applications, including monitoring and Bitcoin.
4. Adding new applications is straightforward due to Application of Applications pattern.

