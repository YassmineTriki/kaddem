# Étape de build
FROM eclipse-temurin:17-jdk-alpine as builder

WORKDIR /app

# Copie sélective pour une meilleure efficacité du cache Docker
COPY pom.xml .
COPY src ./src
COPY mvnw .
COPY .mvn .mvn

# Donne les permissions d'exécution à mvnw
RUN chmod +x mvnw

# Build l'application
RUN ./mvnw clean package -DskipTests

# Étape d'exécution
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]