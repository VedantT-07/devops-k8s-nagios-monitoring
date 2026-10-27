#!/bin/bash
# One-click deployment script for Member 1 (Kubernetes Cluster Lead)
set -e

echo "=================================================="
echo " [Member 1] Deploying Kubernetes Infrastructure..."
echo "=================================================="

# Check kubectl
if ! command -v kubectl &> /dev/null; then
    echo "[-] Error: kubectl command not found. Please install kubectl."
    exit 1
fi

echo "[1/5] Applying Namespace..."
kubectl apply -f 01-namespace.yaml

echo "[2/5] Applying ConfigMap (Custom Web UI Dashboard)..."
kubectl apply -f 02-configmap.yaml

echo "[3/5] Applying Production Deployment (Nginx Microservice)..."
kubectl apply -f 03-deployment.yaml

echo "[4/5] Applying NodePort Service (:30080)..."
kubectl apply -f 04-service.yaml

echo "[5/5] Applying Horizontal Pod Autoscaler..."
kubectl apply -f 05-hpa.yaml

echo ""
echo "==> Waiting for deployment rollout to finish..."
kubectl rollout status deployment/production-webapp -n devops-monitoring --timeout=60s

echo ""
echo "=================================================="
echo " Infrastructure Status:"
echo "=================================================="
kubectl get all -n devops-monitoring

CLUSTER_IP=$(minikube ip 2>/dev/null || echo "127.0.0.1")
echo ""
echo "[+] SUCCESS: Application endpoint is live at: http://${CLUSTER_IP}:30080"
echo "=================================================="
