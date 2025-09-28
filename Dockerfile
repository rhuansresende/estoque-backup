FROM postgres:15

# Instala cron, bash, dos2unix e tzdata para timezone correto
RUN apt-get update && apt-get install -y \
    cron \
    bash \
    dos2unix \
    tzdata \
 && rm -rf /var/lib/apt/lists/*

# Configura timezone para São Paulo
ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Define diretório de trabalho
WORKDIR /app

# Copia scripts de backup e entrypoint
COPY dev/ /app/dev/
COPY hom/ /app/hom/
COPY prod/ /app/prod/
COPY entrypoint.sh /app/

# Converte todos os .sh para LF (evita erro de CRLF do Windows)
RUN dos2unix /app/*.sh /app/*/*.sh

# Garante permissão de execução nos scripts
RUN chmod +x /app/entrypoint.sh \
    /app/dev/run_backup.sh \
    /app/hom/run_backup.sh \
    /app/prod/run_backup.sh

# Define o entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]