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

COPY --from=build /app/target/*.jar /booking-service.jar

# Установка bash для wait-for-it.sh
RUN apk add --no-cache bash

COPY wait-for-it.sh .

RUN chmod +x wait-for-it.sh

# Установка переменных окружения
ENV POSTGRES_HOST=database
ENV POSTGRES_PORT=5432
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_DB=reservations_db

ENV RABBIT_MQ_HOST=rabbitmq
ENV RABBIT_MQ_PORT=5672
ENV RABBIT_MQ_USER=guest
ENV RABBIT_MQ_PASSWORD=guest
ENV RABBIT_MQ_QUEUE_NAME=messagequeue
ENV RABBIT_MQ_EXCHANGE=messagequeue-exchange

ENV HOTEL_SERVICE_HOST=hotel-service
ENV HOTEL_SERVICE_PORT=8082

ENV PAYMENT_SERVICE_HOST=payment-service
ENV PAYMENT_SERVICE_PORT=8084

ENV LOYALTY_SERVICE_HOST=loyalty-service
ENV LOYALTY_SERVICE_PORT=8085



# Настройка команды запуска с ожиданием всех зависимостей
ENTRYPOINT ["./wait-for-it.sh", "database:5432", "--", \
            "./wait-for-it.sh", "rabbitmq:5672", "--", \
            "./wait-for-it.sh", "hotel-service:8082", "--", \
            "./wait-for-it.sh", "payment-service:8084", "--", \
            "./wait-for-it.sh", "loyalty-service:8085", "--", \
            "java", "-jar", "/booking-service.jar"]
