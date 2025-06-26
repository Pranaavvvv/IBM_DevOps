@echo off
setlocal enabledelayedexpansion

echo ========================================
echo Library Management System - Local Setup
echo ========================================
echo.

set "COMMAND=%1"

if "%COMMAND%"=="" (
    echo Usage: %0 [COMMAND]
    echo.
    echo Commands:
    echo   check-prereq     Check if Java, Maven, Docker are installed
    echo   build-test       Build and test the Java application
    echo   docker-build     Build Docker image
    echo   docker-run       Run Docker container
    echo   docker-stop      Stop Docker container
    echo   monitoring-up    Start monitoring stack
    echo   monitoring-down  Stop monitoring stack
    echo   run-pipeline     Run complete local DevOps pipeline
    echo   stop-all         Stop all services
    echo   help             Show this help message
    echo.
    echo Examples:
    echo   %0 check-prereq
    echo   %0 run-pipeline
    echo   %0 stop-all
    echo.
    echo This local version runs completely on your machine without requiring:
    echo - AWS account or credentials
    echo - Terraform
    echo - Ansible
    echo - SSH keys
    echo - DockerHub account
    echo.
    echo Perfect for learning DevOps concepts locally!
    goto :eof
)

if "%COMMAND%"=="help" (
    echo Usage: %0 [COMMAND]
    echo.
    echo Commands:
    echo   check-prereq     Check if Java, Maven, Docker are installed
    echo   build-test       Build and test the Java application
    echo   docker-build     Build Docker image
    echo   docker-run       Run Docker container
    echo   docker-stop      Stop Docker container
    echo   monitoring-up    Start monitoring stack
    echo   monitoring-down  Stop monitoring stack
    echo   run-pipeline     Run complete local DevOps pipeline
    echo   stop-all         Stop all services
    echo   help             Show this help message
    goto :eof
)

if "%COMMAND%"=="check-prereq" (
    echo [INFO] Checking prerequisites...
    echo.
    
    echo Checking Java...
    java -version >nul 2>&1
    if %errorlevel% equ 0 (
        echo [SUCCESS] Java is installed
    ) else (
        echo [ERROR] Java is not installed or not in PATH
    )
    
    echo Checking Maven...
    mvn -version >nul 2>&1
    if %errorlevel% equ 0 (
        echo [SUCCESS] Maven is installed
    ) else (
        echo [ERROR] Maven is not installed or not in PATH
    )
    
    echo Checking Docker...
    docker --version >nul 2>&1
    if %errorlevel% equ 0 (
        echo [SUCCESS] Docker is installed
    ) else (
        echo [ERROR] Docker is not installed or not in PATH
    )
    
    echo.
    echo [INFO] Prerequisites check completed!
    goto :eof
)

if "%COMMAND%"=="build-test" (
    echo [INFO] Building and testing the application...
    echo.
    
    echo [INFO] Cleaning and compiling...
    call mvn clean compile
    if %errorlevel% neq 0 (
        echo [ERROR] Maven compile failed!
        exit /b 1
    )
    
    echo [INFO] Running tests...
    call mvn test
    if %errorlevel% neq 0 (
        echo [ERROR] Tests failed!
        exit /b 1
    )
    
    echo [INFO] Packaging application...
    call mvn package -DskipTests
    if %errorlevel% neq 0 (
        echo [ERROR] Packaging failed!
        exit /b 1
    )
    
    echo [SUCCESS] Build and test completed successfully!
    goto :eof
)

if "%COMMAND%"=="docker-build" (
    echo [INFO] Building Docker image...
    
    docker build -t library-management-system .
    if %errorlevel% neq 0 (
        echo [ERROR] Docker build failed!
        exit /b 1
    )
    
    echo [SUCCESS] Docker image built successfully!
    goto :eof
)

if "%COMMAND%"=="docker-run" (
    echo [INFO] Running Docker container...
    
    docker run -d --name library-app -p 8080:8080 library-management-system
    if %errorlevel% neq 0 (
        echo [ERROR] Docker run failed!
        exit /b 1
    )
    
    echo [SUCCESS] Docker container started!
    echo [INFO] Application should be accessible at http://localhost:8080
    goto :eof
)

if "%COMMAND%"=="docker-stop" (
    echo [INFO] Stopping Docker container...
    
    docker stop library-app 2>nul
    docker rm library-app 2>nul
    
    echo [SUCCESS] Docker container stopped and removed!
    goto :eof
)

if "%COMMAND%"=="monitoring-up" (
    echo [INFO] Setting up monitoring stack...
    
    cd monitoring
    docker-compose up -d
    if %errorlevel% neq 0 (
        echo [ERROR] Monitoring setup failed!
        exit /b 1
    )
    
    echo [SUCCESS] Monitoring stack started!
    echo [INFO] Grafana: http://localhost:3000 (admin/admin)
    echo [INFO] Graphite: http://localhost:8080
    goto :eof
)

if "%COMMAND%"=="monitoring-down" (
    echo [INFO] Stopping monitoring stack...
    
    cd monitoring
    docker-compose down
    
    echo [SUCCESS] Monitoring stack stopped!
    goto :eof
)

if "%COMMAND%"=="run-pipeline" (
    echo [INFO] Running complete local DevOps pipeline...
    echo.
    
    echo [INFO] Step 1: Building and testing...
    call %0 build-test
    if %errorlevel% neq 0 exit /b 1
    
    echo [INFO] Step 2: Building Docker image...
    call %0 docker-build
    if %errorlevel% neq 0 exit /b 1
    
    echo [INFO] Step 3: Stopping any existing container...
    call %0 docker-stop
    
    echo [INFO] Step 4: Running new container...
    call %0 docker-run
    if %errorlevel% neq 0 exit /b 1
    
    echo [INFO] Step 5: Starting monitoring...
    call %0 monitoring-up
    if %errorlevel% neq 0 exit /b 1
    
    echo.
    echo [SUCCESS] Complete local DevOps pipeline finished!
    echo [INFO] Your application is now running locally with full DevOps pipeline!
    echo.
    echo [INFO] Access points:
    echo [INFO] - Application: http://localhost:8080
    echo [INFO] - Grafana Dashboard: http://localhost:3000 (admin/admin)
    echo [INFO] - Graphite Metrics: http://localhost:8080
    echo.
    echo [INFO] To stop everything:
    echo [INFO]   %0 stop-all
    goto :eof
)

if "%COMMAND%"=="stop-all" (
    echo [INFO] Stopping all services...
    
    call %0 docker-stop
    call %0 monitoring-down
    
    echo [SUCCESS] All services stopped!
    goto :eof
)

echo [ERROR] Unknown command: %COMMAND%
echo [INFO] Run '%0 help' for available commands
exit /b 1 