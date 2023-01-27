#!/bin/bash
#
# Script de backup para a AWS S3, utilizando o tar para compactar o arquivo
# e gerando um arquivo de log ao final da execução.
#
# Escrito por: Ailton Borges
#
# Variáveis de configuração
DB_NAME=mydatabase
DB_USER=myuser
DB_PASS=mypassword
S3_BUCKET=s3://my-bucket-name/

# Data e hora atuais para usar no nome do arquivo de backup e log
DATE=$(date +%Y-%m-%d_%H-%M-%S)

# Criando o arquivo de backup
mysqldump --user=$DB_USER --password=$DB_PASS $DB_NAME > backup-$DATE.sql

# Compactando o arquivo de backup
tar -zcvf backup-$DATE.tar.gz backup-$DATE.sql

# Removendo o arquivo de backup original
rm -f backup-$DATE.sql

# Enviando o arquivo de backup compactado para o S3
aws s3 cp backup-$DATE.tar.gz $S3_BUCKET >> backup-log-$DATE.txt 2>&1

# Removendo o arquivo de backup local
rm -f backup-$DATE.tar.gz

# Verificando o status de retorno da cópia do arquivo de backup para o S3
if [ $? -eq 0 ]; then
    echo "Backup realizado com sucesso em $DATE" >> backup-log-$DATE.txt
else
    echo "Falha ao realizar backup em $DATE" >> backup-log-$DATE.txt
fi
