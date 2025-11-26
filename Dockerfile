# ====== BUILD STAGE ======
FROM maven:3.9.9-eclipse-temurin-24 AS build

WORKDIR /app

# Copy only pom first to cache dependencies
COPY pom.xml .
RUN mvn -q -DskipTests dependency:go-offline

# Now copy source and build
COPY src ./src
RUN mvn -q -DskipTests package

# ====== RUNTIME STAGE ======
FROM eclipse-temurin:24-jre

WORKDIR /app

# Copy generated JAR from build stage
# If your final JAR name is known, you can use it instead of *.jar
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
