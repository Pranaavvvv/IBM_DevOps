# Library Management System - DevOps CI/CD Pipeline

A complete DevOps CI/CD pipeline project demonstrating the deployment of a Java-based Library Management System using modern DevOps tools and practices.

## 🏗️ Project Overview

This project showcases a full DevOps pipeline including:
- **Java Maven Application** - Library Management System with addBook and hasBook functionality
- **JUnit Testing** - Comprehensive unit tests
- **Docker Containerization** - Multi-stage Docker build
- **Jenkins CI/CD Pipeline** - Automated build, test, and deployment
- **Terraform Infrastructure** - AWS EC2 provisioning
- **Ansible Deployment** - Application deployment automation
- **Graphite + Grafana Monitoring** - Metrics collection and visualization

## 📁 Project Structure

```
library-management-system/
├── src/
│   ├── main/java/com/library/
│   │   ├── Book.java              # Book entity
│   │   ├── Library.java           # Main library logic
│   │   └── LibraryApplication.java # Application entry point
│   └── test/java/com/library/
│       ├── BookTest.java          # Book unit tests
│       └── LibraryTest.java       # Library unit tests
├── terraform/
│   ├── main.tf                    # AWS infrastructure
│   ├── variables.tf               # Terraform variables
│   └── outputs.tf                 # Terraform outputs
├── ansible/
│   └── deploy.yml                 # Ansible deployment playbook
├── monitoring/
│   ├── docker-compose.yml         # Graphite + Grafana stack
│   ├── graphite/conf/             # Graphite configuration
│   └── grafana/                   # Grafana dashboards
├── pom.xml                        # Maven configuration
├── Dockerfile                     # Docker containerization
├── Jenkinsfile                    # Jenkins CI/CD pipeline
└── README.md                      # This file
```

## 🚀 Quick Start

### Prerequisites

1. **Java 11+** and **Maven 3.6+**
2. **Docker** and **Docker Compose**
3. **Jenkins** with required plugins
4. **Terraform** 1.0+
5. **Ansible** 2.9+
6. **AWS CLI** configured
7. **SSH key pair** for EC2 access

### 1. Build and Test Locally

```bash
# Navigate to project directory
cd library-management-system

# Build the project
mvn clean compile

# Run tests
mvn test

# Package the application
mvn package

# Run the application
java -jar target/library-management-system-1.0.0.jar
```

### 2. Docker Operations

```bash
# Build Docker image
docker build -t library-management-system .

# Run container locally
docker run -p 8080:8080 library-management-system

# Push to DockerHub (replace with your username)
docker tag library-management-system your-username/library-management-system
docker push your-username/library-management-system
```

### 3. Infrastructure with Terraform

```bash
# Navigate to terraform directory
cd terraform

# Initialize Terraform
terraform init

# Plan the infrastructure
terraform plan

# Apply the infrastructure
terraform apply

# Get the EC2 public IP
terraform output public_ip
```

### 4. Deploy with Ansible

```bash
# Navigate to ansible directory
cd ansible

# Deploy to EC2 (replace with actual IP)
ansible-playbook -i "EC2_IP," -u ubuntu --private-key ~/.ssh/id_rsa deploy.yml \
  -e "docker_image=your-username/library-management-system:latest"
```

### 5. Start Monitoring Stack

```bash
# Navigate to monitoring directory
cd monitoring

# Start Graphite and Grafana
docker-compose up -d

# Access Grafana at http://localhost:3000 (admin/admin)
# Access Graphite at http://localhost:8080
```

## 🔧 Configuration

### Jenkins Setup

1. **Install Required Plugins:**
   - Docker Pipeline
   - Terraform
   - Ansible
   - Pipeline Utility Steps
   - HTML Publisher

2. **Configure Credentials:**
   - `dockerhub-credentials` - DockerHub username/password
   - `aws-credentials` - AWS access key/secret
   - SSH key for EC2 access

3. **Update Jenkinsfile:**
   - Replace `your-dockerhub-username` with your DockerHub username
   - Update email addresses in notifications
   - Adjust AWS region if needed

### AWS Configuration

1. **Configure AWS CLI:**
```bash
aws configure
```

2. **Create SSH Key Pair:**
```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
```

3. **Update Terraform Variables:**
   - Modify `terraform/variables.tf` for your region/instance type
   - Ensure SSH public key path is correct

### Monitoring Configuration

1. **Graphite Configuration:**
   - Metrics are sent to `localhost:2003`
   - Web interface at `localhost:8080`

2. **Grafana Configuration:**
   - Default login: `admin/admin`
   - Graphite datasource is pre-configured
   - Library dashboard is automatically imported

## 📊 Metrics and Monitoring

The application collects the following metrics:

- **library.books.added** - Counter for books added
- **library.books.searched** - Counter for book searches
- **library.addbook.duration** - Timer for add book operations
- **library.searchbook.duration** - Timer for search operations

### Viewing Metrics

1. **Graphite Web Interface:** http://localhost:8080
2. **Grafana Dashboard:** http://localhost:3000
   - Login: admin/admin
   - Navigate to Library Management System Dashboard

## 🧪 Testing

### Run All Tests
```bash
mvn test
```

### Run Specific Test Class
```bash
mvn test -Dtest=LibraryTest
```

### Generate Test Report
```bash
mvn surefire-report:report
```

## 🔄 CI/CD Pipeline Flow

1. **Code Commit** → Git repository
2. **Jenkins Trigger** → Pipeline starts
3. **Build** → Maven compile and package
4. **Test** → JUnit tests execution
5. **Docker Build** → Create container image
6. **Docker Push** → Push to DockerHub
7. **Terraform Plan** → Infrastructure planning
8. **Terraform Apply** → Provision AWS resources
9. **Ansible Deploy** → Deploy application to EC2
10. **Health Check** → Verify deployment
11. **Notification** → Email success/failure

## 🛠️ Troubleshooting

### Common Issues

1. **Maven Build Fails:**
   - Ensure Java 11+ is installed
   - Check Maven version: `mvn --version`
   - Clear Maven cache: `mvn clean`

2. **Docker Build Fails:**
   - Ensure Docker is running
   - Check Docker daemon: `docker info`
   - Clear Docker cache: `docker system prune`

3. **Terraform Errors:**
   - Verify AWS credentials: `aws sts get-caller-identity`
   - Check SSH key exists: `ls ~/.ssh/id_rsa.pub`
   - Initialize Terraform: `terraform init`

4. **Ansible Connection Issues:**
   - Verify SSH key permissions: `chmod 600 ~/.ssh/id_rsa`
   - Test SSH connection: `ssh -i ~/.ssh/id_rsa ubuntu@EC2_IP`
   - Check security group allows SSH (port 22)

5. **Monitoring Not Working:**
   - Ensure Docker Compose is running
   - Check container status: `docker-compose ps`
   - View logs: `docker-compose logs`

### Log Locations

- **Application Logs:** Container logs via `docker logs`
- **Jenkins Logs:** Jenkins console output
- **Terraform Logs:** `terraform apply` output
- **Ansible Logs:** Playbook execution output
- **Monitoring Logs:** `docker-compose logs`

## 📚 Learning Resources

- [Maven Documentation](https://maven.apache.org/guides/)
- [Docker Documentation](https://docs.docker.com/)
- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Ansible Documentation](https://docs.ansible.com/)
- [Graphite Documentation](https://graphite.readthedocs.io/)
- [Grafana Documentation](https://grafana.com/docs/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For issues and questions:
1. Check the troubleshooting section
2. Review the logs
3. Create an issue with detailed information
4. Include error messages and environment details

---

**Happy DevOps Learning! 🚀** 