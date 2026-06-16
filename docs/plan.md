# Project Plan

## Objective

Build a production-inspired Kubernetes platform on AWS using Terraform, Ansible, GitOps, observability, secrets management, CI/CD, and SRE practices.

The focus is on demonstrating platform engineering, infrastructure automation, Kubernetes operations, and incident management rather than application development.

---

## Current Progress

### Infrastructure Foundation

* [x] Create Terraform project structure
* [x] Create reusable VPC module
* [x] Create reusable Security Group module
* [x] Create reusable EC2 module

### Networking

* [x] Create VPC
* [x] Create public subnets
* [x] Create private subnets
* [x] Create Internet Gateway
* [x] Create public route table
* [x] Associate public subnets with route table

### Security

* [x] Create Bastion Security Group
* [x] Create Kubernetes Node Security Group
* [x] Create AWS Key Pair using Terraform

### Compute

* [x] Deploy Bastion Host
* [x] Deploy Control Plane EC2
* [x] Deploy Worker Node EC2

### Access Validation

* [x] Configure SSH Agent Forwarding
* [x] Validate Bastion access
* [x] Validate Bastion → Control Plane access
* [x] Validate Bastion → Worker access

---

## Next Steps

### Networking Completion

* [ ] Create NAT Instance
* [ ] Disable Source/Destination Check
* [ ] Configure IP Forwarding
* [ ] Configure NAT Rules (iptables)
* [ ] Create Private Route Table
* [ ] Associate Private Subnets
* [ ] Validate outbound internet access from private nodes

### Ansible Foundation

* [ ] Generate inventory from Terraform outputs
* [ ] Create common role
* [ ] Configure OS prerequisites
* [ ] Disable swap
* [ ] Configure sysctl settings
* [ ] Install containerd
* [ ] Validate idempotent execution

### Kubernetes Bootstrap

* [ ] Initialize control plane with kubeadm
* [ ] Join worker nodes
* [ ] Configure kubectl access
* [ ] Install Calico CNI
* [ ] Install Metrics Server
* [ ] Validate cluster health

### GitOps

* [ ] Install ArgoCD
* [ ] Configure GitOps repository structure
* [ ] Deploy sample workload through ArgoCD
* [ ] Enable auto-sync

### Application Layer

* [ ] Deploy PostgreSQL
* [ ] Deploy FastAPI backend
* [ ] Deploy React frontend
* [ ] Configure ingress and routing

### Secrets Management

* [ ] Install Vault
* [ ] Configure Vault policies
* [ ] Configure Vault Agent Injector
* [ ] Install Sealed Secrets
* [ ] Demonstrate secret management workflow

### Observability

* [ ] Install Prometheus
* [ ] Install Grafana
* [ ] Install Alertmanager
* [ ] Install Loki
* [ ] Create dashboards
* [ ] Configure alerting

### API Gateway

* [ ] Install Gateway API
* [ ] Install Envoy Gateway
* [ ] Install cert-manager
* [ ] Deploy KrakenD
* [ ] Configure JWT validation
* [ ] Configure rate limiting

### CI/CD

* [ ] Configure GitHub Actions
* [ ] Build and push images
* [ ] Configure ECR
* [ ] Install Tekton
* [ ] Configure deployment pipeline
* [ ] Integrate with ArgoCD

### Reliability & SRE

* [ ] Configure HPA
* [ ] Define resource requests and limits
* [ ] Configure Network Policies
* [ ] Create backup strategy
* [ ] Document RTO/RPO

### Incident Scenarios

* [ ] Worker node failure simulation
* [ ] Pod crash/OOM simulation
* [ ] Secret rotation failure simulation
* [ ] Create postmortems
* [ ] Track MTTR and MTBF

# AIOps & Intelligent Operations

## Objective

Leverage LLMs and AI-driven automation to enhance observability, incident response, root cause analysis, and operational efficiency.

The focus is on demonstrating practical AIOps capabilities integrated with Kubernetes, observability, and SRE workflows.

---

## AI Foundation

- [ ] Deploy AI Operations Service (FastAPI)
- [ ] Integrate OpenAI API or local LLM (Ollama/Mistral/Llama)
- [ ] Create prompt management framework
- [ ] Create AI workflow orchestration layer
- [ ] Implement API authentication and rate limiting

---

## AI Log Analysis

### Goal

Automatically analyze logs and generate actionable insights.

- [ ] Integrate Loki API
- [ ] Fetch logs based on service and time range
- [ ] Implement log summarization
- [ ] Detect recurring errors
- [ ] Detect anomaly patterns
- [ ] Generate root cause suggestions
- [ ] Generate remediation recommendations

### Example

```text
Input:
Analyze logs for payment-service over last 30 minutes

Output:
- Database connection pool exhausted
- 500 errors increased by 18%
- Recommended action:
  Increase pool size or investigate DB latency
```

---

## AI Incident Response Assistant

### Goal

Correlate metrics, logs, and cluster events to accelerate investigations.

- [ ] Integrate Prometheus API
- [ ] Integrate Loki API
- [ ] Integrate Kubernetes API
- [ ] Collect deployment history
- [ ] Correlate alerts with events
- [ ] Generate incident summaries
- [ ] Generate probable root causes
- [ ] Generate recommended actions

### Example

```text
Alert:
High CPU Usage

AI Investigation:

- CPU increased after deployment v2.3.1
- Error rate increased by 15%
- Increased request latency observed

Probable Root Cause:
Memory leak introduced in recent deployment

Recommended Action:
Rollback deployment and investigate heap usage
```

---

## AI-Powered Alert Enrichment

### Goal

Transform raw alerts into actionable alerts.

- [ ] Integrate Alertmanager webhook
- [ ] Create alert enrichment service
- [ ] Fetch relevant metrics
- [ ] Fetch recent logs
- [ ] Attach AI-generated context
- [ ] Send enriched alerts to Slack/Discord

### Example

```text
Raw Alert:
PodCrashLoopBackOff

Enriched Alert:
Affected Service: payment-service
Likely Cause: Missing environment variable
Recent Change: Secret updated 10 minutes ago
Suggested Investigation:
kubectl describe pod
kubectl get events
```

---

## AI ChatOps Assistant

### Goal

Provide operational insights through natural language.

- [ ] Deploy Discord or Slack Bot
- [ ] Integrate Kubernetes API
- [ ] Integrate Prometheus
- [ ] Integrate Loki
- [ ] Implement tool/function calling

### Supported Commands

```text
/status payment-service

/logs payment-service

/analyze payment-service

/incident last

/cpu payment-service
```

### Natural Language Examples

```text
Why is payment-service unhealthy?

Show errors from last hour.

What caused the latest incident?
```

---

## AI Runbook Generation

### Goal

Automatically generate investigation steps.

- [ ] Create runbook template engine
- [ ] Generate incident-specific runbooks
- [ ] Store runbooks in Git repository
- [ ] Integrate with ArgoCD documentation repository

### Example

```text
Incident:
CrashLoopBackOff

Generated Runbook:

1. Describe pod
2. Review pod events
3. Check container logs
4. Verify secrets/configmaps
5. Validate image version
```

---

## AI Postmortem Assistant

### Goal

Reduce post-incident documentation effort.

- [ ] Collect alert timeline
- [ ] Collect deployment events
- [ ] Collect remediation actions
- [ ] Generate incident summary
- [ ] Generate postmortem draft
- [ ] Generate lessons learned section

### Outputs

- Incident Summary
- Timeline
- Root Cause
- Corrective Actions
- Preventive Actions

---

## AI Knowledge Base (RAG)

### Goal

Create an operational knowledge assistant.

- [ ] Store runbooks
- [ ] Store postmortems
- [ ] Store architecture documents
- [ ] Implement Retrieval-Augmented Generation (RAG)
- [ ] Enable semantic search

### Example Queries

```text
How was the previous OOM incident resolved?

Show runbook for Vault outage.

What is the procedure for worker replacement?
```

---

## AI-Enhanced Incident Scenarios

### Worker Node Failure

- [ ] Trigger worker node shutdown
- [ ] Generate AI investigation report
- [ ] Measure AI-assisted MTTR

### Pod CrashLoopBackOff

- [ ] Trigger application failure
- [ ] Generate root cause analysis

### OOM Kill Scenario

- [ ] Trigger memory exhaustion
- [ ] Validate AI recommendations

### Secret Rotation Failure

- [ ] Trigger secret mismatch
- [ ] Validate AI remediation guidance

---

## AI Architecture

```text
                    +-------------------+
                    |   Slack/Discord   |
                    +---------+---------+
                              |
                              v
                    +-------------------+
                    |  AI ChatOps Bot   |
                    +---------+---------+
                              |
                              v
                    +-------------------+
                    | AI Ops Service    |
                    |    (FastAPI)      |
                    +----+----+----+----+
                         |    |    |
                         |    |    |
         +---------------+    |    +---------------+
         |                    |                    |
         v                    v                    v

 +---------------+   +---------------+   +---------------+
 | Prometheus    |   | Loki          |   | Kubernetes    |
 | Metrics API   |   | Logs API      |   | Events API    |
 +---------------+   +---------------+   +---------------+

                         |
                         v

                +-------------------+
                |   LLM / Ollama    |
                | OpenAI / Mistral  |
                +-------------------+

                         |
                         v

      +------------------------------------------+
      | RCA Reports                              |
      | Alert Enrichment                         |
      | Runbook Generation                       |
      | Postmortem Generation                    |
      | Knowledge Base Responses                 |
      +------------------------------------------+
```

---

## Additional Deliverables

- AI Log Analysis Platform
- AI Incident Response Assistant
- AI Alert Enrichment Service
- AI ChatOps Bot
- AI Runbook Generator
- AI Postmortem Generator
- Operational Knowledge Base (RAG)
- AI-Assisted Root Cause Analysis Reports

---