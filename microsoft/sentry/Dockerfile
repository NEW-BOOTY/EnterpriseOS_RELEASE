FROM amazonlinux:2
RUN yum install -y java-17-amazon-corretto
COPY java/target/sentry-1.0.0.jar /app.jar
CMD ["java", "-jar", "/app.jar"]
