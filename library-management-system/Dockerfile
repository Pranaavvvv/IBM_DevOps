# Use Maven to build the app
FROM maven:3.8.4-openjdk-11 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Use OpenJDK for running the app
FROM openjdk:11-jre-slim
WORKDIR /app
COPY --from=builder /app/target/library-management-system-1.0.0.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"] 