# ─── STAGE 1: Build ───────────────────────────────────────────────
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copiar pom.xml primero (cacheo de dependencias)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copiar el resto del proyecto y compilar
COPY src ./src
RUN mvn clean package -DskipTests -B

# ─── STAGE 2: Runtime ─────────────────────────────────────────────
FROM tomcat:9.0-jdk17-temurin

# Limpiar apps por defecto de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiar el WAR generado
COPY --from=build /app/target/Quiddity.war /usr/local/tomcat/webapps/ROOT.war

# Encoding UTF-8
ENV JAVA_OPTS="-Dfile.encoding=UTF-8 -Dserver.timezone=America/Bogota"

EXPOSE 8080

CMD ["catalina.sh", "run"]