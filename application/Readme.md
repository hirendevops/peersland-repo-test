User Interaction:
Users interact with the frontend application running in their browser. This includes actions like logging in, sending messages, and navigating through the chat interface.Frontend (React App):The frontend is responsible for rendering the user interface and handling user inputs.It communicates with the backend via HTTP requests (for RESTful APIs) and WebSocket connections (for real-time interactions).

Backend (Node.js/Express + Socket.io):

The backend handles all the server-side logic.It processes API requests from the frontend to perform actions such as user authentication, message retrieval, and message storage.Socket.io is used to manage real-time bi-directional communication between the frontend and the backend. This allows for instant messaging features, such as showing when users are typing or when new messages are sent.
MongoDB (Database):

MongoDB stores all persistent data for the application, including user profiles, chat messages, and any other relevant data.The backend interacts with MongoDB to retrieve, add, update, or delete data based on the requests it receives from the frontend.

Create Sp FOR Azure
 az ad sp create-for-rbac   --name "sp-terraform-aks"   --role "Contributor"   --scopes /subscriptions/fb054262-2097-4672-a006-c9c5f87ed11c  --sdk-auth




Create an Azure Container Registry (ACR)

Create Azure Container Registry (ACR)
az acr create \
  --resource-group demo-rg \
  --name  demo-np-rg\
  --sku Basic \
  --admin-enabled tru
--name must be globally unique (e.g., demoacr12345)
--sku can be Basic, Standard, or Premium
--admin-enabled true lets you use simple username/password login (useful for testing)
Build a Docker image locally

go to backen folder execute below command
cd backend/
az acr build   --registry peerslandbackend   --image peerslandbackend:v1
cd frontend/
az acr build   --registry peerslandfrontend   --image peerslandfrontend:v1
Log in and push it to ACR

