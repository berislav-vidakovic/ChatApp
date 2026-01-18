# ChatApp

**ChatApp** is a full-stack real-time messaging application built with **React**, **Spring Boot**, and **MongoDB**.  
It demonstrates modern backend and frontend development practices including REST APIs, WebSockets, JWT authentication, Docker-based deployment, and CI/CD automation.


<div style="margin-bottom: 12px;">
<img src = "docs/images/ts.png" style="margin-right: 15px;" /> 
<img src = "docs/images/react.png" style="margin-right: 15px;" /> 
<img src = "docs/images/rest.png" style="margin-right: 15px;" /> 
<img src = "docs/images/java.png" style="margin-right: 15px;" /> 
<img src = "docs/images/spring1.png" style="margin-right: 15px;" /> 
<img src = "docs/images/mongodb.png" style="margin-right: 15px;" /> 
<img src = "docs/images/CI-CD.png" style="margin-right: 15px;" /> 
</div>


This project is designed as a **portfolio project** to showcase real-world engineering skills and production-ready architecture.


---

## 📑 Table of Contents

- [🚀 Features / Live Demo](#features--live-demo)
- [🧰 Tech Stack](#tech-stack)
- [📁 Project Structure](#project-structure)
- [🛠️ Local Development](#local-development)
- [🐳 Docker containers](#docker-containers)
- [⚙️ Environment Variables](#environment-variables)
- [🌐 NGINX Reverse Proxy](#nginx-reverse-proxy)
- [🔁 CI/CD](#cicd)
- [🎯 Skills demonstrated](#skills-demonstrated)
- [👨‍💻 Contact](#contact)
- [📄 License](#license)

---

## Features / Live Demo

- Real-time messaging using **WebSockets**
- RESTful API for users, chats, and messages
- JWT-based authentication
- Role-Based Access Control (RBAC)
- MongoDB persistence
- Docker support
- NGINX reverse proxy configuration
- GitHub & GitLab Actions CI/CD pipelines


> 🔗 Demo: https://chatapp-test.barryonweb.com/ 

- To test full functionality open 2 browsers and login with 2 different users 
- Either register new users or use existing ones all having password abc  
- Basic role enables sending messages, no new chat, no user admin
- Prime role is required to create new chat
- Admin role is required for user role management 


📸 Screenshot of ChatApp in action:

![ChatApp Screenshot](/docs/images/chatapp.png "Chat App in action")

---

## Tech Stack

### Backend
- Java 21
- Spring Boot
- Spring Web / WebSocket
- MongoDB (more details in  <a href="docs/Details.md">separate document</a> )
- JWT Authentication
- There are more details in  <a href="backend/Readme.md">separate document</a> )


### Frontend 
- React 
- TypeScript
- Vite
- There are more details in  <a href="frontend/README.md">separate document</a> )


### Infrastructure & DevOps
- Docker containerization
- NGINX
- GitHub & GitLab Actions (CI/CD)
- Linux (systemd, SSH)

### Configuration & Secrets

- All sensitive values (DB credentials, JWT secrets, API keys) are externalized via environment variables and are not committed to the repository
- Example configuration is provided in .env.template


---

## Project Structure

```text
/
├── backend/                            # Spring Boot backend
├── frontend/                           # React frontend
├── nginx/                              # NGINX configs for Dev, Test and Prod environments
├── docs/                               # Project documentation
├── runTestContainer.sh                 # Bash script for test container recreation
├── docker-compose.yml                  # Docker compose for production container recreation
├── rebuildAppContainer.sh              # Bash script to run Docker compose and restore DB
├── .github/workflows/                  # GitHub CI/CD pipelines 
├── .gitlab.yml                         # GitLab CI/CD pipeline 
└── Readme.md
```

---

## Local Development

### Backend

```bash
mvn clean package -DskipTests
set -a
source .env
set +a
java -jar target/chatappjn-0.0.1-SNAPSHOT.jar
```

- Env. variables including backend Port are defined in .env (included in .gitgnore) 

---

### Frontend

```bash
cd frontend
npm install
npm run build
```

---

## Docker containers

### Build Image and run Frontend and Backend Docker containers connected to Host DB (Test)

```bash
./runTestContainer.sh
```

### Build Image and run Frontend, Backend and MongoDb Docker containers  (Prod)


```bash
./rebuildAppContainer.sh
```

There is a <a href="docs/DockerContainer.md">separate document</a> with more details on Docker containerization.

---

## Environment Variables

```yaml
# .env
MONGO_URI
MONGO_DB
SPRING_PROFILES_ACTIVE
SERVER_PORT
JWT_SECRET
```

---

## NGINX Reverse Proxy

NGINX is used as a reverse proxy for REST APIs, WebSockets, and frontend assets.

```nginx
location /api/ {
  proxy_pass http://127.0.0.1:8081;
}

location /websocket {
  proxy_pass http://127.0.0.1:8081;
  proxy_http_version 1.1;
  proxy_set_header Upgrade $http_upgrade;
  proxy_set_header Connection "Upgrade";
}
```

---

## CI/CD

The project includes **GitHub & GitLab Actions workflows**  for automated build and deployment of backend and frontend services.

---

## Skills demonstrated

- Demonstrate real-time application architecture
- Secure authentication and authorization
- Clean backend–frontend separation
- Production-ready deployment
- Dockerized environments
- Infrastructure automation

---

## Contact

**Berislav Vidakovic**  
- GitHub: https://github.com/berislav-vidakovic 
- Blog: https://barrytheanalyst.eu 
- LinkedIn: https://www.linkedin.com/in/berislav-vidakovic/
- E-mail: berislav.vidakovic@gmail.com
---

## License

MIT License
