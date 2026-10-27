#!/bin/bash
# Deploy or update the containerized application
echo "==> Deploying Kubernetes Application..."
kubectl apply -f web-app.yaml

echo "==> Waiting for pods to become ready..."
kubectl rollout status deployment/production-webapp --timeout=60s

echo "==> Deployment Summary:"
kubectl get pods,svc -l app=production-webapp -o wide