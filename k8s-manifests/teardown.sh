#!/bin/bash
# Clean teardown script for Kubernetes manifests
echo "Tearing down Kubernetes resources in 'devops-monitoring'..."
kubectl delete -f 05-hpa.yaml --ignore-not-found
kubectl delete -f 04-service.yaml --ignore-not-found
kubectl delete -f 03-deployment.yaml --ignore-not-found
kubectl delete -f 02-configmap.yaml --ignore-not-found
kubectl delete -f 01-namespace.yaml --ignore-not-found
echo "Teardown complete."
