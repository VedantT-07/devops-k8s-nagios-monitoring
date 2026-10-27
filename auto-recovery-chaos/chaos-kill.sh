#!/bin/bash
# Chaos Injection Script: simulates a production outage by scaling the web app to 0 replicas
NAMESPACE="${NAMESPACE:-devops-monitoring}"
DEPLOYMENT="production-webapp"
 
echo "[CHAOS] Intentionally killing Kubernetes Web Service..."
kubectl scale deployment "$DEPLOYMENT" --replicas=0 -n "$NAMESPACE"
echo "[CHAOS] Scaled $DEPLOYMENT to 0 replicas in namespace $NAMESPACE. Outage active."
kubectl get pods -n "$NAMESPACE"
