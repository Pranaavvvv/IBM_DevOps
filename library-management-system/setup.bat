@echo off
setlocal enabledelayedexpansion

REM Library Management System - DevOps CI/CD Pipeline Setup Script for Windows
REM This script helps set up and run the complete DevOps pipeline

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

REM Function to check prerequisites
:check_prereq
call :print_status "Checking prerequisites..."

set "missing_tools="

call :command_exists java
if %errorlevel% neq 0 set "missing_tools=!missing_tools! Java"

call :command_exists mvn
if %errorlevel% neq 0 set "missing_tools=!missing_tools! Maven"

call :command_exists docker
if %errorlevel% neq 0 set "missing_tools=!missing_tools! Docker"

call :command_exists terraform
if %errorlevel% neq 0 set "missing_tools=!missing_tools! Terraform"

call :command_exists ansible
if %errorlevel% neq 0 set "missing_tools=!missing_tools! Ansible"

if not "%missing_tools%"=="" (
    call :print_error "Missing required tools:!missing_tools!"
    call :print_status "Please install the missing tools and run this script again."
    exit /b 1
)

call :print_success "All prerequisites are installed!"
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

REM Function to initialize Terraform
:tf_init
call :print_status "Initializing Terraform..."

cd /d "%SCRIPT_DIR%\terraform"

terraform init
if %errorlevel% neq 0 (
    call :print_error "Terraform init failed!"
    exit /b 1
)

call :print_success "Terraform initialized!"
goto :eof

REM Function to plan Terraform
:tf_plan
call :print_status "Planning Terraform infrastructure..."

cd /d "%SCRIPT_DIR%\terraform"

terraform plan
if %errorlevel% neq 0 (
    call :print_error "Terraform plan failed!"
    exit /b 1
)

call :print_success "Terraform plan completed!"
goto :eof

REM Function to apply Terraform
:tf_apply
call :print_status "Applying Terraform infrastructure..."

cd /d "%SCRIPT_DIR%\terraform"

terraform apply -auto-approve
if %errorlevel% neq 0 (
    call :print_error "Terraform apply failed!"
    exit /b 1
)

call :print_success "Terraform infrastructure deployed!"

REM Get the public IP
for /f "tokens=*" %%i in ('terraform output -raw public_ip') do set "public_ip=%%i"
call :print_status "EC2 Public IP: %public_ip%"
goto :eof

REM Function to destroy Terraform infrastructure
:tf_destroy
call :print_warning "This will destroy all AWS infrastructure!"
set /p "confirm=Are you sure? (y/N): "
if /i "%confirm%"=="y" (
    call :print_status "Destroying Terraform infrastructure..."
    
    cd /d "%SCRIPT_DIR%\terraform"
    
    terraform destroy -auto-approve
    if %errorlevel% neq 0 (
        call :print_error "Terraform destroy failed!"
        exit /b 1
    )
    
    call :print_success "Terraform infrastructure destroyed!"
) else (
    call :print_status "Terraform destroy cancelled."
)
goto :eof

REM Function to deploy with Ansible
:deploy_ansible
if "%2"=="" (
    call :print_error "Please provide the EC2 public IP as an argument"
    call :print_status "Usage: %0 deploy-ansible EC2_IP"
    exit /b 1
)

set "ec2_ip=%2"
call :print_status "Deploying with Ansible to %ec2_ip%..."

cd /d "%SCRIPT_DIR%\ansible"

ansible-playbook -i "%ec2_ip%," -u ubuntu --private-key ~/.ssh/id_rsa deploy.yml -e "docker_image=your-username/library-management-system:latest"
if %errorlevel% neq 0 (
    call :print_error "Ansible deployment failed!"
    exit /b 1
)

call :print_success "Ansible deployment completed!"
goto :eof

REM Function to show help
:show_help
echo Library Management System - DevOps CI/CD Pipeline Setup Script for Windows
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
echo   tf-init          Initialize Terraform
echo   tf-plan          Plan Terraform infrastructure
echo   tf-apply         Apply Terraform infrastructure
echo   tf-destroy       Destroy Terraform infrastructure
echo   deploy-ansible   Deploy with Ansible (requires EC2_IP)
echo   all              Run complete setup (build, test, docker, monitoring)
echo   help             Show this help message
echo.
echo Examples:
echo   %0 build-test
echo   %0 docker-run
echo   %0 deploy-ansible 1.2.3.4
echo   %0 all
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
if "%COMMAND%"=="tf-init" goto tf_init
if "%COMMAND%"=="tf-plan" goto tf_plan
if "%COMMAND%"=="tf-apply" goto tf_apply
if "%COMMAND%"=="tf-destroy" goto tf_destroy
if "%COMMAND%"=="deploy-ansible" goto deploy_ansible
if "%COMMAND%"=="all" (
    call :check_prereq
    if %errorlevel% neq 0 exit /b 1
    call :build_test
    if %errorlevel% neq 0 exit /b 1
    call :docker_build
    if %errorlevel% neq 0 exit /b 1
    call :docker_run
    if %errorlevel% neq 0 exit /b 1
    call :monitoring_up
    if %errorlevel% neq 0 exit /b 1
    call :print_success "Complete setup finished!"
    call :print_status "Next steps:"
    call :print_status "1. Initialize Terraform: %0 tf-init"
    call :print_status "2. Plan infrastructure: %0 tf-plan"
    call :print_status "3. Deploy infrastructure: %0 tf-apply"
    call :print_status "4. Deploy application: %0 deploy-ansible EC2_IP"
    goto :eof
)
if "%COMMAND%"=="help" goto show_help

call :print_error "Unknown command: %COMMAND%"
call :show_help
exit /b 1 