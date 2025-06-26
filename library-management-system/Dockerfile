# Multi-stage build for Java application
FROM maven:3.8.4-openjdk-11 AS builder

# Set working directory
WORKDIR /app

# Copy pom.xml first for better layer caching
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Runtime stage
FROM openjdk:11-jre-slim

# Set working directory
WORKDIR /app

# Copy the built JAR from builder stage
COPY --from=builder /app/target/library-management-system-1.0.0.jar app.jar

# Create a non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser
USER appuser

# Expose port (if needed for future web interface)
EXPOSE 8080

# Set JVM options for better performance
ENV JAVA_OPTS="-Xmx512m -Xms256m"

# Run the application
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"] 