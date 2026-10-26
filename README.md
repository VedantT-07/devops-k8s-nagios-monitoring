# DevOps Enterprise Monitoring & Auto-Recovery System

An enterprise-grade centralized observability and self-healing framework using **Kubernetes**, **Nagios Core 4.x**, **NCPA Agent**, and **Telegram/SMTP ChatOps**.

---

## 📁 Repository Structure & Team Ownership

```
devops-k8s-nagios-monitoring/
├── README.md
├── .gitignore
├── k8s-manifests/          # [Member 1] Kubernetes Deployment, Service, and Cluster configs
├── nagios-core/            # [Member 2] Nagios Core server configs, hosts, and services definitions
├── alerting-escalation/    # [Member 3] Contacts, Escalation policies, and Telegram notification scripts
└── auto-recovery-chaos/    # [Member 4] Self-healing Event Handlers and Chaos injection test scripts
```

---

## 👥 Team Roles

| Directory | Owner | Responsibilities |
| :--- | :--- | :--- |
| `k8s-manifests/` | **Member 1** | Kubernetes cluster deployment (`web-app.yaml`), NodePort exposure, replica configuration. |
| `nagios-core/` | **Member 2** | Nagios Core setup, `k8s-services.cfg`, Windows monitoring via NCPA (`windows-node.cfg`). |
| `alerting-escalation/` | **Member 3** | Postfix/SMTP email relay, Telegram Bot script (`telegram-notify.sh`), `contacts.cfg`, `escalations.cfg`. |
| `auto-recovery-chaos/` | **Member 4** | Auto-healing event handler (`k8s-auto-heal.sh`), passwordless sudo setup, and chaos simulation (`chaos-kill.sh`). |

---

## 🚀 Quick Start

Refer to [DevOps_K8s_Nagios_Implementation_Plan.md](./DevOps_K8s_Nagios_Implementation_Plan.md) for detailed phase-by-phase implementation instructions and viva defense notes.
