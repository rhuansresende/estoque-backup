FROM postgres:15

# Instala cron e bash
RUN apt-get update && apt-get install -y cron bash && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copia todos os scripts por ambiente
COPY dev/ /app/dev/
COPY hom/ /app/hom/
COPY prod/ /app/prod/
COPY entrypoint.sh /app/

# Converte todos os scripts para LF
RUN dos2unix /app/*.sh /app/*/*.sh

RUN chmod +x /app/dev/run_backup.sh /app/hom/run_backup.sh /app/prod/run_backup.sh /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
