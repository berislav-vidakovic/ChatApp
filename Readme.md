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

- [🚀 Features](#features)
- [🧰 Tech Stack](#tech-stack)
- [📁 Project Structure](#project-structure)
- [🛠️ Local Development](#local-development)
- [🐳 Docker (Test Environment)](#docker-test-environment)
- [⚙️ Environment Variables](#environment-variables)
- [🌐 NGINX Reverse Proxy](#nginx-reverse-proxy)
- [🔁 CI/CD](#cicd)
- [🎯 Skills demonstrated](#skills-demonstrated)
- [👨‍💻 Contact](#contact)
- [📄 License](#license)

---

## Features

- Real-time messaging using **WebSockets**
- RESTful API for users, chats, and messages
- JWT-based authentication
- Role-Based Access Control (RBAC)
- MongoDB persistence
- Docker support
- NGINX reverse proxy configuration
- GitHub Actions CI/CD pipelines

---

## Tech Stack

### Backend
- Java 21
- Spring Boot
- Spring Web / WebSocket
- MongoDB (more details in  <a href="docs/Details.md">separate document</a> )
- JWT Authentication

### Frontend
- React
- TypeScript
- Vite

### Infrastructure & DevOps
- Docker containerization
- NGINX
- GitHub Actions (CI/CD)
- Linux (systemd, SSH)

---

## Project Structure

```text
/
├── backend/                    # Spring Boot backend
├── frontend/                   # React frontend
├── runTestContainer.sh         # Helper script for container recreation
├── chatapp-test.barryonweb.com # NGINX config for Test environment
├── chatapp-dev.barryonweb.com  # NGINX config for Dev environment
└── Readme.md
```

---

## Local Development

### Backend

```bash
cd backend
mvn clean package -DskipTests
java -jar target/chatappjn-0.0.1-SNAPSHOT.jar
```

Default backend port:
```
http://localhost:8081
```

---

### Frontend

```bash
cd frontend
npm install
npm run build
```

---

## Docker (Test Environment)

### Run script to Build Image and run Docker container

```bash
./runTestContainer.sh
```

There is a <a href="docs/Details.md">separate document</a> with more details on Docker containerization.

---

## Environment Variables

```yaml
MONGO_URI=mongodb://user:password@host:27017/chatapp_test
MONGO_DB=chatapp_test
SPRING_PROFILES_ACTIVE=prod
JAVA_OPTS="-Xms256m -Xmx512m"
SPRING_SERVER_PORT=8080
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

The project includes **GitHub Actions workflows** for automated build and deployment of backend and frontend services.

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
