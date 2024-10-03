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

COPY --from=build /app/target/*.jar /gateway-service.jar

# Установка bash для wait-for-it.sh
RUN apk add --no-cache bash

COPY wait-for-it.sh .

RUN chmod +x wait-for-it.sh

ENV SESSION_SERVICE_HOST=session-service
ENV SESSION_SERVICE_PORT=8081

ENV HOTEL_SERVICE_HOST=hotel-service
ENV HOTEL_SERVICE_PORT=8082

ENV BOOKING_SERVICE_HOST=booking-service
ENV BOOKING_SERVICE_PORT=8083

ENV PAYMENT_SERVICE_HOST=payment-service
ENV PAYMENT_SERVICE_PORT=8084

ENV LOYALTY_SERVICE_HOST=loyalty-service
ENV LOYALTY_SERVICE_PORT=8085

ENV REPORT_SERVICE_HOST=report-service
ENV REPORT_SERVICE_PORT=8086

# Настройка команды запуска с ожиданием всех зависимостей
ENTRYPOINT ["./wait-for-it.sh", "session-service:8081", "--", \
            "./wait-for-it.sh", "hotel-service:8082", "--", \
            "./wait-for-it.sh", "booking-service:8083", "--", \
            "./wait-for-it.sh", "payment-service:8084", "--", \
            "./wait-for-it.sh", "loyalty-service:8085", "--", \
            "./wait-for-it.sh", "report-service:8086", "--", \
            "java", "-jar", "/gateway-service.jar"]
