# Этап сборки
FROM maven:3.8.6-openjdk-8 as build

WORKDIR /app

COPY .mvn .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:go-offline

COPY src src
RUN ./mvnw package -DskipTests


# Этап выполнения
FROM openjdk:8-jdk-alpine

WORKDIR /app

COPY --from=build /app/target/*.jar /loyalty-service.jar

# Установка bash для wait-for-it.sh
RUN apk add --no-cache bash

COPY wait-for-it.sh .

RUN chmod +x wait-for-it.sh

# Установка переменных окружения
ENV POSTGRES_HOST=database
ENV POSTGRES_PORT=5432
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_DB=balances_db

# Настройка команды запуска с ожиданием Postgres
ENTRYPOINT ["./wait-for-it.sh", "database:5432", "--", \
            "java", "-jar", "/loyalty-service.jar"]
