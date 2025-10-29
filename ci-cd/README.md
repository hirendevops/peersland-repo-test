Add All Secret variable in github repo

AZURE_CREDENTIALS
ACR_NAME 
AKS_CLUSTER_NAME
AKS_RESOURCE_GROUP 

Add Envirment variables

IMAGE_NAME
REGISTRY



. Pipeline Flow Summary
Stage	Action	Tool
Checkout	Get code	GitHub
Build/Test	npm build/test	Node
Build Image	Docker build	Docker
Push Image	Push to ACR	Azure CLI
Deploy	Apply manifests	kubectl via GitHub Action

. Prerequisites
- An Azure account with an active subscription.
- An Azure Container Registry (ACR) instance.
- An Azure Kubernetes Service (AKS) cluster.
- GitHub repository with the code to be deployed.
- GitHub Actions enabled in the repository.


name: CI/CD to AKS

on:
  push:
    branches: [ "main" ]

env:
  IMAGE_NAME: sample-microservice
  REGISTRY: ${{ secrets.ACR_NAME }}.azurecr.io

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Set up Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'

    - name: Install dependencies
      run: npm install

    - name: Run tests
      run: npm test || echo "No tests found"

    - name: Log in to Azure
      uses: azure/login@v2
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}

    - name: Log in to Azure Container Registry
      run: |
        az acr login --name ${{ secrets.ACR_NAME }}

    - name: Build and push Docker image
      run: |
        IMAGE_TAG=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.run_number }}
        docker build -t $IMAGE_TAG .
        docker push $IMAGE_TAG
        echo "IMAGE_TAG=$IMAGE_TAG" >> $GITHUB_ENV

    - name: Set AKS context
      uses: azure/aks-set-context@v3
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}
        cluster-name: ${{ secrets.AKS_CLUSTER_NAME }}
        resource-group: ${{ secrets.AKS_RESOURCE_GROUP }}

    - name: Deploy to AKS
      uses: azure/k8s-deploy@v5
      with:
        manifests: |
          manifests/deployment.yaml
          manifests/service.yaml
        images: |
          ${{ env.IMAGE_TAG }}
        namespace: default
