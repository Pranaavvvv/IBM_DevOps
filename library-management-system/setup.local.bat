@echo off
setlocal enabledelayedexpansion

REM Library Management System - Local DevOps CI/CD Pipeline Setup Script for Windows
REM This script helps set up and run the complete DevOps pipeline locally (no AWS required)

set "SCRIPT_DIR=%~dp0"
set "COMMAND=%1"

REM Function to print colored output
:print_status
echo [INFO] %~1
goto :eof

:print_success
echo [SUCCESS] %~1
goto :eof

:print_warning
echo [WARNING] %~1
goto :eof

:print_error
echo [ERROR] %~1
goto :eof

REM Function to check if command exists
:command_exists
where %1 >nul 2>&1
if %errorlevel% equ 0 (
    exit /b 0
) else (
    exit /b 1
)

REM Function to check local prerequisites
:check_prereq
call :print_status "Checking local prerequisites..."

set "missing_tools="

call :command_exists java
if %errorlevel% neq 0 set "missing_tools=!missing_tools! Java"

call :command_exists mvn
if %errorlevel% neq 0 set "missing_tools=!missing_tools! Maven"

call :command_exists docker
if %errorlevel% neq 0 set "missing_tools=!missing_tools! Docker"

if not "%missing_tools%"=="" (
    call :print_error "Missing required tools:!missing_tools!"
    call :print_status "Please install the missing tools and run this script again."
    exit /b 1
)

call :print_success "All local prerequisites are installed!"
goto :eof

REM Function to build and test the application
:build_test
call :print_status "Building and testing the application..."

cd /d "%SCRIPT_DIR%"

REM Clean and compile
call :print_status "Cleaning and compiling..."
call mvn clean compile
if %errorlevel% neq 0 (
    call :print_error "Maven compile failed!"
    exit /b 1
)

REM Run tests
call :print_status "Running tests..."
call mvn test
if %errorlevel% neq 0 (
    call :print_error "Tests failed!"
    exit /b 1
)

REM Package
call :print_status "Packaging application..."
call mvn package -DskipTests
if %errorlevel% neq 0 (
    call :print_error "Packaging failed!"
    exit /b 1
)

call :print_success "Build and test completed successfully!"
goto :eof

REM Function to build Docker image
:docker_build
call :print_status "Building Docker image..."

cd /d "%SCRIPT_DIR%"

docker build -t library-management-system .
if %errorlevel% neq 0 (
    call :print_error "Docker build failed!"
    exit /b 1
)

call :print_success "Docker image built successfully!"
goto :eof

REM Function to run Docker container
:docker_run
call :print_status "Running Docker container..."

cd /d "%SCRIPT_DIR%"

docker run -d --name library-app -p 8080:8080 library-management-system
if %errorlevel% neq 0 (
    call :print_error "Docker run failed!"
    exit /b 1
)

call :print_success "Docker container started!"
call :print_status "Application should be accessible at http://localhost:8080"
goto :eof

REM Function to stop Docker container
:docker_stop
call :print_status "Stopping Docker container..."

docker stop library-app 2>nul
docker rm library-app 2>nul

call :print_success "Docker container stopped and removed!"
goto :eof

REM Function to set up monitoring
:monitoring_up
call :print_status "Setting up monitoring stack..."

cd /d "%SCRIPT_DIR%\monitoring"

docker-compose up -d
if %errorlevel% neq 0 (
    call :print_error "Monitoring setup failed!"
    exit /b 1
)

call :print_success "Monitoring stack started!"
call :print_status "Grafana: http://localhost:3000 (admin/admin)"
call :print_status "Graphite: http://localhost:8080"
goto :eof

REM Function to stop monitoring
:monitoring_down
call :print_status "Stopping monitoring stack..."

cd /d "%SCRIPT_DIR%\monitoring"

docker-compose down

call :print_success "Monitoring stack stopped!"
goto :eof

REM Function to run the complete local pipeline
:run_pipeline
call :print_status "Running complete local DevOps pipeline..."

REM Build and test
call :build_test
if %errorlevel% neq 0 exit /b 1

REM Build Docker image
call :docker_build
if %errorlevel% neq 0 exit /b 1

REM Stop any existing container
call :docker_stop

REM Run new container
call :docker_run
if %errorlevel% neq 0 exit /b 1

REM Start monitoring
call :monitoring_up
if %errorlevel% neq 0 exit /b 1

call :print_success "Complete local DevOps pipeline finished!"
call :print_status "Your application is now running locally with full DevOps pipeline!"
call :print_status ""
call :print_status "Access points:"
call :print_status "- Application: http://localhost:8080"
call :print_status "- Grafana Dashboard: http://localhost:3000 (admin/admin)"
call :print_status "- Graphite Metrics: http://localhost:8080"
call :print_status ""
call :print_status "To stop everything:"
call :print_status "  setup.local.bat stop-all"
goto :eof

REM Function to stop everything
:stop_all
call :print_status "Stopping all services..."

call :docker_stop
call :monitoring_down

call :print_success "All services stopped!"
goto :eof

REM Function to show application logs
:show_logs
call :print_status "Showing application logs..."

docker logs library-app --tail 50
goto :eof

REM Function to show monitoring logs
:show_monitoring_logs
call :print_status "Showing monitoring logs..."

cd /d "%SCRIPT_DIR%\monitoring"
docker-compose logs --tail 20
goto :eof

REM Function to restart application
:restart_app
call :print_status "Restarting application..."

call :docker_stop
call :docker_run

call :print_success "Application restarted!"
goto :eof

REM Function to show help
:show_help
echo Library Management System - Local DevOps CI/CD Pipeline Setup Script for Windows
echo.
echo Usage: %0 [COMMAND]
echo.
echo Commands:
echo   check-prereq     Check if all required tools are installed
echo   build-test       Build and test the Java application
echo   docker-build     Build Docker image
echo   docker-run       Run Docker container
echo   docker-stop      Stop Docker container
echo   monitoring-up    Start monitoring stack (Graphite + Grafana)
echo   monitoring-down  Stop monitoring stack
echo   run-pipeline     Run complete local DevOps pipeline
echo   stop-all         Stop all services (app + monitoring)
echo   show-logs        Show application logs
echo   show-monitoring  Show monitoring logs
echo   restart-app      Restart application
echo   help             Show this help message
echo.
echo Examples:
echo   %0 check-prereq
echo   %0 run-pipeline
echo   %0 stop-all
echo   %0 show-logs
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

REM Main script logic
if "%COMMAND%"=="" goto show_help

if "%COMMAND%"=="check-prereq" goto check_prereq
if "%COMMAND%"=="build-test" goto build_test
if "%COMMAND%"=="docker-build" goto docker_build
if "%COMMAND%"=="docker-run" goto docker_run
if "%COMMAND%"=="docker-stop" goto docker_stop
if "%COMMAND%"=="monitoring-up" goto monitoring_up
if "%COMMAND%"=="monitoring-down" goto monitoring_down
if "%COMMAND%"=="run-pipeline" goto run_pipeline
if "%COMMAND%"=="stop-all" goto stop_all
if "%COMMAND%"=="show-logs" goto show_logs
if "%COMMAND%"=="show-monitoring" goto show_monitoring_logs
if "%COMMAND%"=="restart-app" goto restart_app
if "%COMMAND%"=="help" goto show_help

call :print_error "Unknown command: %COMMAND%"
call :show_help
exit /b 1 