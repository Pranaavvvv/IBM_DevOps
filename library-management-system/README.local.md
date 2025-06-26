# Library Management System - Local DevOps CI/CD Pipeline

A complete DevOps CI/CD pipeline project that runs **entirely locally** without requiring AWS, cloud accounts, or external services. Perfect for learning DevOps concepts on your own machine!

## 🏠 **Local-Only Benefits**

✅ **No AWS account required**  
✅ **No cloud costs**  
✅ **No external dependencies**  
✅ **No SSH keys needed**  
✅ **No DockerHub account required**  
✅ **Runs completely offline**  
✅ **Perfect for learning and development**

## 🏗️ **What You'll Learn**

This local version demonstrates all the core DevOps concepts:

- **Java Maven Application** - Library Management System with addBook and hasBook functionality
- **JUnit Testing** - Comprehensive unit tests with 100% coverage
- **Docker Containerization** - Multi-stage Docker builds
- **Jenkins CI/CD Pipeline** - Automated build, test, and deployment
- **Monitoring Stack** - Graphite + Grafana for metrics visualization
- **Local Deployment** - Container orchestration and health checks

## 📁 **Project Structure**

```
library-management-system/
├── 📄 pom.xml                           # Maven configuration
├── 📄 Dockerfile                        # Multi-stage Docker build
├── 📄 Jenkinsfile.local                 # Local CI/CD pipeline
├── 📄 setup.local.bat                   # Windows setup script
├── 📄 README.local.md                   # This file
├── 📂 src/
│   ├── 📂 main/java/com/library/
│   │   ├── 📄 Book.java                 # Book entity
│   │   ├── 📄 Library.java              # Main library logic
│   │   └── 📄 LibraryApplication.java   # Application entry point
│   └── 📂 test/java/com/library/
│       ├── 📄 BookTest.java             # Book unit tests
│       └── 📄 LibraryTest.java          # Library unit tests
└── 📂 monitoring/
    ├── 📄 docker-compose.yml            # Graphite + Grafana stack
    ├── 📂 graphite/conf/                # Graphite configuration
    └── 📂 grafana/                      # Grafana dashboards
```

## 🚀 **Quick Start (Windows)**

### **Prerequisites (Minimal!)**

You only need **3 tools** installed:

1. **Java 11+** - Download from Oracle or OpenJDK
2. **Maven 3.6+** - Download from Apache Maven
3. **Docker Desktop** - Download from Docker

### **Step 1: Check Prerequisites**
```cmd
cd library-management-system
setup.local.bat check-prereq
```

### **Step 2: Run Complete Pipeline**
```cmd
setup.local.bat run-pipeline
```

That's it! Your application will be running locally with full DevOps pipeline.

## 🎯 **What Happens When You Run the Pipeline**

1. **Build** → Maven compiles and packages the Java application
2. **Test** → JUnit runs all tests and generates reports
3. **Docker Build** → Creates optimized container image
4. **Deploy** → Runs application in Docker container
5. **Monitor** → Starts Graphite + Grafana monitoring stack
6. **Health Check** → Verifies everything is working

## 🌐 **Access Your Application**

After running the pipeline, you can access:

- **Application**: http://localhost:8080
- **Grafana Dashboard**: http://localhost:3000 (admin/admin)
- **Graphite Metrics**: http://localhost:8080

## 🛠️ **Available Commands**

```cmd
# Check if you have all required tools
setup.local.bat check-prereq

# Build and test the application
setup.local.bat build-test

# Build Docker image
setup.local.bat docker-build

# Run application container
setup.local.bat docker-run

# Start monitoring stack
setup.local.bat monitoring-up

# Run complete pipeline (recommended)
setup.local.bat run-pipeline

# Stop all services
setup.local.bat stop-all

# View application logs
setup.local.bat show-logs

# View monitoring logs
setup.local.bat show-monitoring

# Restart application
setup.local.bat restart-app

# Show help
setup.local.bat help
```

## 📊 **Monitoring & Metrics**

The application automatically collects metrics:

- **library.books.added** - Number of books added
- **library.books.searched** - Number of book searches
- **library.addbook.duration** - Time taken to add books
- **library.searchbook.duration** - Time taken to search books

### **Viewing Metrics**

1. **Grafana Dashboard**: http://localhost:3000
   - Login: `admin` / `admin`
   - Pre-configured dashboard shows all metrics

2. **Graphite Web Interface**: http://localhost:8080
   - Raw metrics data and graphs

## 🧪 **Testing**

### **Run All Tests**
```cmd
setup.local.bat build-test
```

### **Test Coverage**
The project includes comprehensive tests:
- ✅ Book entity tests
- ✅ Library functionality tests
- ✅ Edge case testing (null values, duplicates)
- ✅ Metrics collection tests

## 🔄 **CI/CD Pipeline (Jenkins)**

If you want to run Jenkins locally:

1. **Install Jenkins** (optional)
2. **Use Jenkinsfile.local** instead of the full Jenkinsfile
3. **Pipeline stages**:
   - Checkout code
   - Build with Maven
   - Run tests
   - Package application
   - Build Docker image
   - Deploy locally
   - Health check
   - Start monitoring

## 🐳 **Docker Operations**

### **Manual Docker Commands**
```cmd
# Build image
docker build -t library-management-system .

# Run container
docker run -d --name library-app -p 8080:8080 library-management-system

# View logs
docker logs library-app

# Stop container
docker stop library-app
docker rm library-app
```

### **Monitoring Stack**
```cmd
# Start monitoring
cd monitoring
docker-compose up -d

# Stop monitoring
docker-compose down

# View monitoring logs
docker-compose logs
```

## 🛠️ **Troubleshooting**

### **Common Issues**

1. **Docker not running**
   ```cmd
   # Start Docker Desktop
   # Check Docker is running:
   docker --version
   ```

2. **Port conflicts**
   ```cmd
   # Check what's using port 8080:
   netstat -ano | findstr :8080
   # Stop conflicting services
   ```

3. **Java not found**
   ```cmd
   # Verify Java installation:
   java -version
   # Add Java to PATH if needed
   ```

4. **Maven not found**
   ```cmd
   # Verify Maven installation:
   mvn -version
   # Add Maven to PATH if needed
   ```

### **Logs and Debugging**

```cmd
# Application logs
setup.local.bat show-logs

# Monitoring logs
setup.local.bat show-monitoring

# Docker container status
docker ps

# Docker container logs
docker logs library-app --tail 50
```

## 🎓 **Learning Path**

This local version is perfect for learning DevOps concepts:

1. **Start with the basics**: Run `setup.local.bat run-pipeline`
2. **Explore the code**: Look at the Java application and tests
3. **Understand Docker**: Examine the Dockerfile and containerization
4. **Learn monitoring**: Explore Graphite and Grafana dashboards
5. **Study CI/CD**: Review the Jenkinsfile.local pipeline
6. **Experiment**: Modify code and see the pipeline in action

## 🔧 **Customization**

### **Modify the Application**
- Edit `src/main/java/com/library/Library.java` to add new features
- Add tests in `src/test/java/com/library/`
- Update `pom.xml` for new dependencies

### **Customize Monitoring**
- Modify `monitoring/grafana/dashboards/library-dashboard.json`
- Update `monitoring/graphite/conf/storage-schemas.conf`
- Add new metrics in the Java application

### **Extend the Pipeline**
- Modify `Jenkinsfile.local` to add new stages
- Update `setup.local.bat` with new commands

## 🆚 **Local vs Cloud Version**

| Feature | Local Version | Cloud Version |
|---------|---------------|---------------|
| **Setup Complexity** | ⭐ Easy (3 tools) | ⭐⭐⭐ Hard (8+ tools) |
| **Cost** | 💰 Free | 💰💰💰 AWS charges |
| **Dependencies** | 🏠 None | ☁️ AWS, DockerHub, etc. |
| **Learning Focus** | 🎓 DevOps concepts | 🚀 Production deployment |
| **Infrastructure** | 🐳 Docker containers | ☁️ AWS EC2, VPC, etc. |
| **Deployment** | 📱 Local machine | 🌐 Cloud servers |

## 🎉 **Success Indicators**

You've successfully learned DevOps when you can:

- ✅ Run the complete pipeline with one command
- ✅ Understand what each stage does
- ✅ Modify the application and see changes
- ✅ View metrics and understand monitoring
- ✅ Troubleshoot issues independently
- ✅ Explain the CI/CD process to others

## 🚀 **Next Steps**

After mastering the local version:

1. **Learn cloud deployment** - Use the full version with AWS
2. **Add more tools** - Kubernetes, Helm, etc.
3. **Build your own project** - Apply these concepts
4. **Join DevOps communities** - Share and learn from others

---

**Happy Local DevOps Learning! 🏠🚀**

*This local version proves you don't need expensive cloud services to learn DevOps concepts effectively!* 