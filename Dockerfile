# Etapa 1: Usar uma imagem Maven para construir o projeto
FROM maven:3.8.6-eclipse-temurin-17 AS builder
WORKDIR /app

# Copiar o arquivo pom.xml e baixar as dependências
COPY pom.xml .
RUN mvn dependency:go-offline

# Copiar o código fonte do projeto
COPY src ./src

# Construir o projeto
RUN mvn clean package -DskipTests

# Etapa 2: Usar uma imagem JRE para executar o JAR da aplicação
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copiar o JAR gerado da fase anterior
COPY --from=builder /app/target/*.jar app.jar

# Definir o comando para rodar a aplicação Spring Boot
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
