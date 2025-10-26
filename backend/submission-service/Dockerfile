# Submission Service Dockerfile for Render.com
FROM eclipse-temurin:21-jdk-jammy AS build

WORKDIR /app

# Copy Maven wrapper and pom.xml
COPY .mvn/ .mvn
COPY mvnw pom.xml ./

# Download dependencies
RUN ./mvnw dependency:go-offline || true

# Copy source code
COPY src ./src

# Build the application
RUN ./mvnw clean package -DskipTests

# Runtime stage
FROM eclipse-temurin:21-jre-jammy

WORKDIR /app

# Copy the jar from build stage
COPY --from=build /app/target/submission-service-1.0.0.jar app.jar

# Create uploads directory
RUN mkdir -p /opt/render/project/uploads

# Expose port
EXPOSE $PORT

# Run the application
ENTRYPOINT ["java", "-Dspring.profiles.active=prod", "-Dserver.port=${PORT}", "-jar", "app.jar"]
