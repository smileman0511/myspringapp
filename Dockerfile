FROM eclipse-temurin:17-jdk-alpine AS builder

WORKDIR /app

COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
COPY src src

RUN chmod +x ./gradlew
RUN ./gradlew build -x test --no-daemon -Dorg.gradle.jvmargs="-Xmx512m"

FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

COPY --from=builder /app/build/libs/myspringapp-1.0.jar app.jar

EXPOSE 10000
CMD ["java", "-jar", "-Dspring.profiles.active=prod", "app.jar"]