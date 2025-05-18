# Define a imagem base com Maven e Java 8
FROM maven:3.6.3-jdk-8

# Define o diretório de trabalho dentro do container
WORKDIR /usr/src/app

# Copia a pasta do projeto Maven para dentro do container
COPY projeto .

# Executa o build do Maven para gerar o arquivo WAR
RUN mvn clean package

# Define a imagem base para executar a aplicação (Tomcat com Java 8)
FROM tomcat:9.0.33-jdk8-openjdk

# Remove a aplicação web padrão do Tomcat (ROOT)
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copia o arquivo WAR gerado pelo Maven para o diretório de deploy do Tomcat
COPY --from=0 /usr/src/app/target/minhaapp.war /usr/local/tomcat/webapps/minhaapp.war

# Expõe a porta padrão do Tomcat
EXPOSE 8080

# Comando para iniciar o servidor Tomcat
CMD ["catalina.sh", "run"]