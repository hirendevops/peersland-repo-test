Install Kubectl in local machine.

To install Kubectl on your local machine, follow the steps below based on your operating system:
### For Linux
1. Download the latest release with the command:
   ```
   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
   ```

#Configure Simple chat-bot applications 
2. Make the kubectl binary executable:
   ```
   chmod +x ./kubectl
   ```
3. Move the binary to your PATH: 
    ```
    sudo mv ./kubectl /usr/local/bin/kubectl
    ``` 

# change chatapp-backend-deployment.yml

      containers:
      - name: chatapp-backend
        image: peerslandbackend.azurecr.io/peerslandbackend:v1
        ports:
        - containerPort: 5001
# change below things in yaml chatapp-frontend-deployment.yaml

       containers:
      - name: chatapp-frontend
        image: peerslandfrontend.azurecr.io/peerslandfrontend:v1
        ports:
        - containerPort: 80
# create configmap and secret for chatbot-app

apiVersion: v1
kind: Secret
metadata:
  name: backend-secrets
  namespace: chat-app
type: Opaque
data:
  mongo-uri: bW9uZ29kYjovL2FkbWluOnBhc3N3b3JkQG1vbmdvZGI6MjcwMTcvY2hhdEFwcD9hdXRoU291cmNlPWFkbWlu
stringData:
  jwt-secret: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJPbmxpbmUgSldUIEJ1aWxkZXIiLCJpYXQiOjE3MzQ3MjA5MzAsImV4cCI6MTc2NjI1NjkzMCwiYXVkIjoidHJhaW53aXRoc2h1YmhhbS5jb20iLCJzdWIiOiJqcm9ja2V0QGV4YW1wbGUuY29tIiwiR2l2ZW5OYW1lIjoiQWZ6YWwiLCJTdXJuYW1lIjoiUm9ja2V0IiwiRW1haWwiOiJqcm9ja2V0QGV4YW1wbGUuY29tIiwiUm9sZSI6WyJEZXZPcHMiLCJQcm9qZWN0IEFkbWluaXN0cmF0b3IiXX0.ehelBbUU2IFJ8M5xzQL_UFatMxCMSojAOqWQaZQgrwk"

  # Add configmap secret Deployment chatapp-backend-deployment.yaml
    env:
        - name: MONGODB_URI
          valueFrom:
            secretKeyRef:
              name: backend-secrets
              key: mongo-uri
        - name: PORT
          value: "5001"
        - name: NODE_ENV
          value: "production"
        - name: JWT_SECRET
          valueFrom:
            secretKeyRef:
              name: backend-secrets
              key: jwt-secret
    


  Configmap Details
     data:
  nginx.conf: |
    server {
      listen 80;
      server_name localhost;
      root /usr/share/nginx/html;
      index index.html;
      
      location / {
        try_files $uri $uri/ /index.html;
      }

      location /api {
        proxy_pass http://backend.chat-app.svc.cluster.local:5001/api/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
      }

      location /socket {
        proxy_pass http://backend.chat-app.svc.cluster.local:5001/socket.io/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
      }
    }

    Craete PV and PVC FOR mongodb host


  After Patch Manuallly volumes will bound to PVC

    kubectl patch storageclass managed-csi -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mongo-pvc
  namespace: chat-app
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: managed-csi

  After Patch Manuallly volumes will bound to PVC

  # Added volumes and volume mount in chatapp-frontend-deployment.yaml
  volumeMounts:
        - name: frontend-data
          mountPath: /etc/nginx/conf.d/default.conf
          subPath: nginx.conf  
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 10
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 15
          periodSeconds: 20
      volumes:
      - name: frontend-data
        configMap:
          name: nginx-config


# Added Ingress Controller 

Step 1: Add NGINX Helm Repo

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

Step 2: Create a Namespace
kubectl create namespace ingress-nginx

Step 3: Install NGINX Ingress Controller

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --set controller.replicaCount=2 \
  --set controller.nodeSelector."kubernetes\.io/os"=linux \
  --set controller.admissionWebhooks.patch.nodeSelector."kubernetes\.io/os"=linux \
  --set controller.service.externalTrafficPolicy=Local \
  --set controller.service.loadBalancerIP="" \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-resource-group"="demo-np-rg"


Step 4: Verify Installation

NAME                                         TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)
ingress-nginx-controller                     LoadBalancer   10.0.252.7     pending   80:32345/TCP,443:31568/TCP

# Create ingress file
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: chatapp-ingress
  namespace: chat-app
  labels:
    name: chatapp-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
  - host: hello.4.246.207.129.nip.io
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: frontend
            port: 
              number: 80
      - pathType: Prefix
        path: "/api"
        backend:
          service:
            name: backend
            port: 
              number: 5001

              









 

    

