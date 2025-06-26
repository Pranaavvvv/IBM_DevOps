# Library Management System - DevOps CI/CD Pipeline

A complete, certification-ready DevOps CI/CD pipeline project for a **Spring Boot Library Management System**. This project demonstrates modern DevOps practices using:

- **GIT** (version control)
- **Maven** (build tool)
- **JUnit** (testing)
- **Jenkins** (CI/CD)
- **Docker** (containerization)
- **Ansible** (deployment/configuration)
- **Graphite + Grafana** (monitoring)

---

## 📚 **Project Overview**

This project implements a RESTful Library Management System with endpoints to add, check, and list books. The full DevOps pipeline automates build, test, containerization, deployment, and monitoring.

---

## 🏗️ **Project Structure**

```
library-management-system/
├── src/
│   ├── main/java/com/library/
│   │   ├── Book.java
│   │   ├── Library.java
│   │   ├── LibraryApplication.java
│   │   └── LibraryController.java
│   └── test/java/com/library/
│       ├── BookTest.java
│       ├── LibraryTest.java
│       └── LibraryControllerTest.java
├── pom.xml
├── Dockerfile
├── Jenkinsfile
├── ansible/
│   └── deploy.yml
├── monitoring/
│   ├── docker-compose.yml
│   └── ... (Graphite/Grafana configs)
└── README.md
```

---

## 🚀 **Quick Start: Local Demo**

### **Prerequisites**
- Java 11+
- Maven 3.6+
- Docker Desktop (running)
- (Optional) Jenkins (for full CI/CD demo)

### **1. Build and Test the App**
```bash
cd library-management-system
mvn clean test
```

### **2. Build and Run with Docker**
```bash
# Build Docker image
docker build -t library-management-system .

# Run the app container
docker run -d --name library-app -p 8080:8080 library-management-system
```

### **3. Start Monitoring Stack**
```bash
cd monitoring
docker-compose up -d
```
- **Grafana:** http://localhost:3000 (login: admin/admin)
- **Graphite:** http://localhost:8080

### **4. Interact with the REST API**
- **Add a book:**
  ```bash
  curl -X POST http://localhost:8080/books \
    -H "Content-Type: application/json" \
    -d '{"isbn":"1234567890","title":"Test Book","author":"Test Author","year":2024}'
  ```
- **Check if a book exists:**
  ```bash
  curl http://localhost:8080/books/1234567890
  ```
- **List all books:**
  ```bash
  curl http://localhost:8080/books
  ```

### **5. Stop Everything**
```bash
docker stop library-app
docker rm library-app
cd monitoring
docker-compose down
```

---

## 🛠️ **CI/CD Pipeline (Jenkins)**

The `Jenkinsfile` automates:
1. **Checkout** (from GIT)
2. **Build** (Maven)
3. **Test** (JUnit)
4. **Package** (Maven)
5. **Docker Build**
6. **Stop Previous Container**
7. **Deploy Locally**
8. **Health Check** (REST endpoint)
9. **Start Monitoring** (Graphite + Grafana)

**To run the pipeline:**
- Set up a Jenkins job with this repo and the provided `Jenkinsfile`.
- Make sure Jenkins can run Docker commands (run as admin or use Docker-in-Docker agent).

---

## 🤖 **Ansible Deployment**

You can use Ansible to deploy the Dockerized app to any Linux host:
```bash
ansible-playbook -i "localhost," -c local ansible/deploy.yml
```
- Edit `docker_image` in the playbook if you push to DockerHub or use a remote host.

---

## 📊 **Monitoring with Graphite & Grafana**

- **Graphite** collects metrics from the app (see `/monitoring/graphite/conf` for retention settings).
- **Grafana** visualizes metrics (see `/monitoring/grafana/dashboards` for dashboards).
- The app can be extended to push custom metrics to Graphite.

---

## 🧪 **Testing**

- **Unit tests:** `mvn test` (JUnit)
- **API tests:** `LibraryControllerTest.java` (Spring Boot MockMvc)

---

## 📝 **How to Demo for Certification**

1. **Show the code and structure** (Spring Boot, Maven, Dockerfile, Jenkinsfile, Ansible, monitoring configs)
2. **Run the pipeline** (locally or in Jenkins)
3. **Show the REST API in action** (add/list/check books)
4. **Show monitoring dashboards** (Grafana/Graphite)
5. **Explain each DevOps tool's role**

---

## 🏆 **DevOps Tools Used**

- **GIT:** Version control for all code and configs
- **Maven:** Build, test, and package the Java app
- **JUnit:** Automated unit and API tests
- **Jenkins:** CI/CD pipeline automation
- **Docker:** Containerization for consistent deployment
- **Ansible:** Automated deployment/configuration
- **Graphite + Grafana:** Monitoring and visualization

---

## 🆘 **Troubleshooting**

- **Docker not running?** Start Docker Desktop and try again.
- **Port 8080/3000 in use?** Stop other services or change ports in Dockerfile/compose.
- **Jenkins can't run Docker?** Make sure Jenkins runs as admin or use a Docker agent.
- **App not accessible?** Check `docker ps` and `docker logs library-app` for errors.

---

## 🎓 **Ready for Certification!**

This project demonstrates a real-world DevOps CI/CD pipeline for a RESTful Java application, using all the required tools. You can run, demo, and explain every step for your certification.

**Good luck! 🚀** 