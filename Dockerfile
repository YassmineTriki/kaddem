# Étape de build
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app

# Copier uniquement les fichiers nécessaires (pas besoin de mvnw ni .mvn)
COPY pom.xml .
COPY src ./src

# Build l’application avec mvn (Maven installé dans l'image officielle)
RUN mvn clean package -DskipTests

# Étape d'exécution
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copier le jar buildé depuis l’étape précédente
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8072

ENTRYPOINT ["java", "-jar", "app.jar"]
