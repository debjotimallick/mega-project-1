# Mega Project 1

A production-style GitOps platform built with Terraform, Ansible, GitHub Actions, and Argo CD.

## What it does

- Uses **Terraform** to provision AWS infrastructure, including EC2 instances.
- Uses **Ansible** to bootstrap a Kubernetes cluster with **kubeadm**.
- Uses **GitHub Actions** for continuous integration and delivery automation.
- Uses **Argo CD** for GitOps-based application deployment.
- Uses **Prometheus** and **Grafana** for metrics and observability.
- Uses **Grafana Loki** for log aggregation and search.
- Uses **HashiCorp Vault** and **Sealed Secrets** for secure secret management.
- Implements SRE scenarios for failure injection and chaos testing.

## Architecture

- Three-tier application:
  - **Frontend**
  - **Backend**
  - **Database**
- Kubernetes cluster deployed on EC2 nodes.
- GitHub repo stores manifests, Terraform code, and deployment pipelines.
- Argo CD syncs the app state from Git to the cluster.

## Key flows

1. **Provision**: Terraform builds the cloud resources.
2. **Bootstrap**: Ansible installs Kubernetes with kubeadm on provisioned hosts.
3. **CI**: GitHub Actions validates code, runs tests, and pushes manifests.
4. **CD**: Argo CD deploys and manages the app.
5. **Observe**: Prometheus/Grafana collect metrics; Loki collects logs.
6. **Secure**: Vault stores secrets; Sealed Secrets protects Kubernetes secrets in Git.

## SRE & resilience

- Chaos tests and failure scenarios validate cluster reliability.
- Observability dashboards and alerting cover app, infra, and Kubernetes health.
- Secret rotation and secure secret distribution are enforced.

## Why this project

This setup demonstrates a full-stack cloud-native delivery pipeline with infrastructure-as-code, configuration management, GitOps deployment, observability, logging, secret management, and reliability engineering.
