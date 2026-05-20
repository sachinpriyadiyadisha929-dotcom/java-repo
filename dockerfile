FROM openjdk:17

WORKDIR /app

COPY target/java-app-1.0.jar app.jar

CMD ["java", "-jar", "app.jar"]
