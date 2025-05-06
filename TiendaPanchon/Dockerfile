# Usar imagen oficial de Tomcat 9
FROM tomcat:9.0

# Limpiar aplicaciones por defecto
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiar WAR del proyecto a la carpeta de despliegue
COPY dist/TiendaPanchon.war /usr/local/tomcat/webapps/TiendaPanchon.war

