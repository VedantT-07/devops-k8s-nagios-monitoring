# Self-Healing Monitoring with Kubernetes + Nagios
 
A small DevOps project where a web app is watched around the clock, the right people get alerted the moment it breaks, and the problem **fixes itself** without anyone touching anything.
 
**Team:** Prranjal Sankhe, Ramalakshmi Annamalai, Vedant Terekholkar, Shlok Ranpise
 
---
 
## What it does
 
1. **Runs the app.** A dark-mode web dashboard runs on Kubernetes (Minikube). Two copies run at all times, so if one dies the other keeps serving users.
2. **Watches the app.** Nagios Core sits outside the app and checks it every 30 seconds by opening the web page, just like a real user would.
3. **Sends alerts.** When the app is confirmed down, alerts go out on **Telegram** and **email** to the DevOps admin and the engineering manager. A recovery message follows when it's fixed.
4. **Heals itself.** Nagios automatically runs a repair script that brings the app back. No human needed.
---
 
## How a failure plays out
 
| Step | What happens |
|---|---|
| 1 | The app is broken on purpose (or fails for real) and stops loading |
| 2 | Nagios turns red and shows **Attempt 1/2**. This is a *soft* state: it double-checks before raising the alarm, in case it was just a blip |
| 3 | Second check also fails: **Attempt 2/2**. The problem is confirmed (a *hard* state) |
| 4 | **CRITICAL** alerts go out on Telegram and email |
| 5 | The repair script runs: if the app was scaled to zero it scales back to 2 copies, and if copies were stuck it restarts them |
| 6 | Nagios checks again, the app is healthy, status turns green |
| 7 | **RECOVERY** messages go out on Telegram and email |
 
Whole cycle: about **one minute**, hands-free.
 
### Why not just let Kubernetes handle it?
Kubernetes is great at restarting crashed containers, but if the app is scaled to zero it thinks everything is fine, because zero is what it was told to run. An outside monitor like Nagios catches this and fixes it.
 
---
 
## Extra features
 
- **Escalation:** if a problem stays unresolved, alerts keep repeating.
- **Scheduled downtime:** silences alerts during planned maintenance (checks and auto-repair still run).
- **Acknowledgement:** a team member can say "I'm on it" and the repeat alerts stop until the service recovers.
- **Safe by design:** the repair script runs with its own limited access, not full admin rights, and no passwords or tokens are stored in this repo.
---
 
## What's in this repo
 
```
.
├── k8s-manifests/         Kubernetes files that define the app
│   └── deploy.sh          Deploys everything in the right order
├── auto-recovery-chaos/   The self-healing script and the "break it" script
│   └── chaos-kill.sh      Breaks the app on purpose for the demo
└── notifications/         Telegram + email alert scripts and contact setup
```
 
> **Note:** contact details in `notifications/` are placeholders (for example `admin@example.com`). Real chat IDs, emails, and tokens are kept only on the machine running Nagios.
 
---
 
## Tools used
 
| Tool | Role |
|---|---|
| VirtualBox + Ubuntu | The machine everything runs on |
| Docker + Minikube | A small Kubernetes cluster |
| Kubernetes + kubectl | Runs the app and keeps 2 copies alive |
| nginx | Serves the web dashboard |
| Nagios Core 4.4 | Monitors the app and decides when to alert and repair |
| Telegram bot | Instant push alerts |
| Postfix + Gmail | Email alerts |
| Git + GitHub | Code storage and sharing |
 
---
 
## Running the demo
 
**Before you start**, make sure:
- Both app copies are running
- Nagios shows the service as green (OK)
- No scheduled downtime or acknowledgement is active
- The auto-repair handler is enabled
- Telegram and Gmail are open on the phones
**Then:**
 
1. Open the dashboard in one browser tab and the Nagios Services page in another
2. Run the failure script:
```bash
   cd auto-recovery-chaos
   ./chaos-kill.sh
```
3. Refresh the dashboard. It's down.
4. Watch Nagios go red (1/2, then 2/2)
5. Watch the CRITICAL alerts arrive on Telegram and email
6. Watch the app heal itself and Nagios go green
7. Watch the RECOVERY messages arrive
---
 
## Settings worth knowing
 
- Checks run every **30 seconds** (fast, for demo purposes; a real setup would use 1 to 5 minutes)
- A failure becomes confirmed after **2 failed checks**
- Alerts repeat about **once a minute** while a problem is unresolved
- Alerts are active **24x7**