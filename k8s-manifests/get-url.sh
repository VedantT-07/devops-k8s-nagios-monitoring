#!/bin/bash
# Get the IP and Port that Nagios needs to monitor
CLUSTER_IP=$(minikube ip 2>/dev/null || echo "127.0.0.1")
echo "=================================================="
echo " Kubernetes Web App Endpoint for Nagios Monitoring:"
echo " URL: http://${CLUSTER_IP}:30080"
echo "=================================================="