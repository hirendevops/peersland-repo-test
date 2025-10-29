Step 1: Add Helm Repositories

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update


Step 2: Create a Monitoring Namespace

kubectl create namespace monitoring

Step 3: Install Prometheus

helm install prometheus prometheus-community/prometheus \
  --namespace monitoring \
  --set alertmanager.persistentVolume.storageClass="default" \
  --set server.persistentVolume.storageClass="default"

Step 4: Access Prometheus (port-forward or ingress)


kubectl port-forward svc/prometheus-server -n monitoring 9090:80


Step 5: Install Grafana

helm install grafana grafana/grafana \
  --namespace monitoring \
  --set persistence.storageClassName="default" \
  --set adminPassword='admin123' \
  --set service.type=LoadBalancer

Step 6: Connect Grafana to Prometheus

Go to Connections → Data Sources → Add data source

Choose Prometheus

In URL, enter:

http://prometheus-server.monitoring.svc.cluster.local

Step 7: Import Dashboards

Go to Grafana → Dashboards → Import

Use these popular IDs (from Grafana.com):

Dashboard	ID	Description
Kubernetes / Nodes	315	Node resource usage
Kubernetes Cluster	6417	Cluster monitoring
NGINX / Ingress	9614	NGINX ingress metrics
Application Metrics	893	Generic app metrics




