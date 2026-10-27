# One-click deployment script for Windows PowerShell
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host " [Member 1] Deploying Kubernetes Infrastructure..." -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

$files = @(
    "01-namespace.yaml",
    "02-configmap.yaml",
    "03-deployment.yaml",
    "04-service.yaml",
    "05-hpa.yaml"
)

foreach ($f in $files) {
    Write-Host "[+] Applying $f..." -ForegroundColor Green
    kubectl apply -f $f
}

Write-Host "`n==> Waiting for deployment rollout to finish..." -ForegroundColor Yellow
kubectl rollout status deployment/production-webapp -n devops-monitoring --timeout=60s

Write-Host "`n==================================================" -ForegroundColor Cyan
Write-Host " Infrastructure Status in 'devops-monitoring' Namespace:" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
kubectl get all -n devops-monitoring

$clusterIp = minikube ip 2>$null
if (-not $clusterIp) { $clusterIp = "127.0.0.1" }
Write-Host "`n[+] SUCCESS: Application endpoint is live at: http://${clusterIp}:30080" -ForegroundColor Green
