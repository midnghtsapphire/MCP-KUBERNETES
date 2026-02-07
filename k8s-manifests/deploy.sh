#!/bin/bash

echo "🚀 Deploying InTheWild platform to Kubernetes..."

# Create namespace
kubectl apply -f namespace.yaml

# Create secrets (you must edit secrets-template.yaml first!)
echo "⚠️  Please edit secrets-template.yaml with your actual secrets before deploying!"
read -p "Have you updated secrets-template.yaml? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Deployment cancelled. Please update secrets first."
    exit 1
fi

kubectl apply -f secrets-template.yaml

# Create ConfigMap
kubectl apply -f configmap.yaml

# Deploy all MCT modules
for file in mct-*-deployment.yaml; do
    echo "📦 Deploying $file..."
    kubectl apply -f "$file"
done

# Create services
for file in mct-*-service.yaml; do
    echo "🔗 Creating service $file..."
    kubectl apply -f "$file"
done

# Create ingress
kubectl apply -f ingress.yaml

# Create HPA
kubectl apply -f hpa.yaml

echo "✅ Deployment complete!"
echo "📊 Check status with: kubectl get pods -n inthewild"
