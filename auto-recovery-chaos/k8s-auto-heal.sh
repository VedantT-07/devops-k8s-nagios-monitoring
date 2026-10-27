#!/bin/bash
# Nagios Event Handler: Automated Kubernetes Service Remediation
# Usage (Nagios): k8s-auto-heal.sh $SERVICESTATE$ $SERVICESTATETYPE$ $SERVICEATTEMPT$
# Manual test:    ./k8s-auto-heal.sh CRITICAL SOFT 1
 
STATE="$1"
STATETYPE="$2"
ATTEMPT="$3"
 
NAMESPACE="${NAMESPACE:-devops-monitoring}"
DEPLOYMENT="production-webapp"
DESIRED_REPLICAS=2
LOGFILE="${LOGFILE:-/var/log/nagios_recovery.log}"
export KUBECONFIG="${KUBECONFIG:-/home/nagios/.kube/config}"
 
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [Attempt $ATTEMPT] [State: $STATE/$STATETYPE] $1" >> "$LOGFILE"
}
 
case "$STATE" in
CRITICAL)
  REPLICAS=$(kubectl get deployment "$DEPLOYMENT" -n "$NAMESPACE" -o jsonpath='{.spec.replicas}' 2>>"$LOGFILE")
 
  if [ -z "$REPLICAS" ]; then
    log "Could not read deployment $DEPLOYMENT in namespace $NAMESPACE (check kubeconfig/cluster). Aborting."
    exit 0
  fi
 
  if [ "$REPLICAS" -eq 0 ] && [ "$STATETYPE" = "HARD" ]; then
    log "CRITICAL: replicas is 0. Scaling $DEPLOYMENT back to $DESIRED_REPLICAS..."
    kubectl scale deployment "$DEPLOYMENT" --replicas="$DESIRED_REPLICAS" -n "$NAMESPACE" >> "$LOGFILE" 2>&1
    log "Scale-up issued. Pods re-provisioning."
  elif [ "$STATETYPE" = "HARD" ]; then
    log "HARD CRITICAL with $REPLICAS replicas. Triggering rollout restart..."
    kubectl rollout restart deployment "$DEPLOYMENT" -n "$NAMESPACE" >> "$LOGFILE" 2>&1
    log "Rollout restart initiated."
  else
    log "SOFT CRITICAL with $REPLICAS replicas. Waiting for HARD state before restarting."
  fi
  ;;
OK)
  log "Service returned to OK state. System healthy."
  ;;
esac
 
exit 0
