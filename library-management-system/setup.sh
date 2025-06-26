#!/bin/bash

# Library Management System - DevOps CI/CD Pipeline Setup Script
# This script helps set up and run the complete DevOps pipeline

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    local missing_tools=()
    
    if ! command_exists java; then
        missing_tools+=("Java")
    fi
    
    if ! command_exists mvn; then
        missing_tools+=("Maven")
    fi
    
    if ! command_exists docker; then
        missing_tools+=("Docker")
    fi
    
    if ! command_exists terraform; then
        missing_tools+=("Terraform")
    fi
    
    if ! command_exists ansible; then
        missing_tools+=("Ansible")
    fi
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        print_error "Missing required tools: ${missing_tools[*]}"
        print_status "Please install the missing tools and run this script again."
        exit 1
    fi
    
    print_success "All prerequisites are installed!"
}

# Function to build and test the application
build_and_test() {
    print_status "Building and testing the application..."
    
    cd "$(dirname "$0")"
    
    # Clean and compile
    print_status "Cleaning and compiling..."
    mvn clean compile
    
    # Run tests
    print_status "Running tests..."
    mvn test
    
    # Package
    print_status "Packaging application..."
    mvn package -DskipTests
    
    print_success "Build and test completed successfully!"
}

# Function to build Docker image
build_docker() {
    print_status "Building Docker image..."
    
    cd "$(dirname "$0")"
    
    docker build -t library-management-system .
    
    print_success "Docker image built successfully!"
}

# Function to run Docker container
run_docker() {
    print_status "Running Docker container..."
    
    cd "$(dirname "$0")"
    
    docker run -d --name library-app -p 8080:8080 library-management-system
    
    print_success "Docker container started!"
    print_status "Application should be accessible at http://localhost:8080"
}

# Function to stop Docker container
stop_docker() {
    print_status "Stopping Docker container..."
    
    docker stop library-app 2>/dev/null || true
    docker rm library-app 2>/dev/null || true
    
    print_success "Docker container stopped and removed!"
}

# Function to set up monitoring
setup_monitoring() {
    print_status "Setting up monitoring stack..."
    
    cd "$(dirname "$0")/monitoring"
    
    docker-compose up -d
    
    print_success "Monitoring stack started!"
    print_status "Grafana: http://localhost:3000 (admin/admin)"
    print_status "Graphite: http://localhost:8080"
}

# Function to stop monitoring
stop_monitoring() {
    print_status "Stopping monitoring stack..."
    
    cd "$(dirname "$0")/monitoring"
    
    docker-compose down
    
    print_success "Monitoring stack stopped!"
}

# Function to initialize Terraform
init_terraform() {
    print_status "Initializing Terraform..."
    
    cd "$(dirname "$0")/terraform"
    
    terraform init
    
    print_success "Terraform initialized!"
}

# Function to plan Terraform
plan_terraform() {
    print_status "Planning Terraform infrastructure..."
    
    cd "$(dirname "$0")/terraform"
    
    terraform plan
    
    print_success "Terraform plan completed!"
}

# Function to apply Terraform
apply_terraform() {
    print_status "Applying Terraform infrastructure..."
    
    cd "$(dirname "$0")/terraform"
    
    terraform apply -auto-approve
    
    print_success "Terraform infrastructure deployed!"
    
    # Get the public IP
    local public_ip=$(terraform output -raw public_ip)
    print_status "EC2 Public IP: $public_ip"
}

# Function to destroy Terraform infrastructure
destroy_terraform() {
    print_warning "This will destroy all AWS infrastructure!"
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Destroying Terraform infrastructure..."
        
        cd "$(dirname "$0")/terraform"
        
        terraform destroy -auto-approve
        
        print_success "Terraform infrastructure destroyed!"
    else
        print_status "Terraform destroy cancelled."
    fi
}

# Function to deploy with Ansible
deploy_ansible() {
    if [ -z "$1" ]; then
        print_error "Please provide the EC2 public IP as an argument"
        print_status "Usage: $0 deploy-ansible <EC2_IP>"
        exit 1
    fi
    
    local ec2_ip=$1
    
    print_status "Deploying with Ansible to $ec2_ip..."
    
    cd "$(dirname "$0")/ansible"
    
    ansible-playbook -i "$ec2_ip," -u ubuntu --private-key ~/.ssh/id_rsa deploy.yml \
        -e "docker_image=your-username/library-management-system:latest"
    
    print_success "Ansible deployment completed!"
}

# Function to show help
show_help() {
    echo "Library Management System - DevOps CI/CD Pipeline Setup Script"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  check-prereq     Check if all required tools are installed"
    echo "  build-test       Build and test the Java application"
    echo "  docker-build     Build Docker image"
    echo "  docker-run       Run Docker container"
    echo "  docker-stop      Stop Docker container"
    echo "  monitoring-up    Start monitoring stack (Graphite + Grafana)"
    echo "  monitoring-down  Stop monitoring stack"
    echo "  tf-init          Initialize Terraform"
    echo "  tf-plan          Plan Terraform infrastructure"
    echo "  tf-apply         Apply Terraform infrastructure"
    echo "  tf-destroy       Destroy Terraform infrastructure"
    echo "  deploy-ansible   Deploy with Ansible (requires EC2_IP)"
    echo "  all              Run complete setup (build, test, docker, monitoring)"
    echo "  help             Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 build-test"
    echo "  $0 docker-run"
    echo "  $0 deploy-ansible 1.2.3.4"
    echo "  $0 all"
}

# Main script logic
case "${1:-help}" in
    "check-prereq")
        check_prerequisites
        ;;
    "build-test")
        build_and_test
        ;;
    "docker-build")
        build_docker
        ;;
    "docker-run")
        run_docker
        ;;
    "docker-stop")
        stop_docker
        ;;
    "monitoring-up")
        setup_monitoring
        ;;
    "monitoring-down")
        stop_monitoring
        ;;
    "tf-init")
        init_terraform
        ;;
    "tf-plan")
        plan_terraform
        ;;
    "tf-apply")
        apply_terraform
        ;;
    "tf-destroy")
        destroy_terraform
        ;;
    "deploy-ansible")
        deploy_ansible "$2"
        ;;
    "all")
        check_prerequisites
        build_and_test
        build_docker
        run_docker
        setup_monitoring
        print_success "Complete setup finished!"
        print_status "Next steps:"
        print_status "1. Initialize Terraform: $0 tf-init"
        print_status "2. Plan infrastructure: $0 tf-plan"
        print_status "3. Deploy infrastructure: $0 tf-apply"
        print_status "4. Deploy application: $0 deploy-ansible <EC2_IP>"
        ;;
    "help"|*)
        show_help
        ;;
esac 