#!/bin/sh
#Script para automação do backup MySQL e envio para o serviço Amazon S3, e envio de arquivo de log anexado por e-mail
#Escrito por: Ailton Borges
#
#
#Declaração de variáveis
now="$(date +'%d_%m_%Y_%H_%M_%S')"
filename="nomedoarquivoBKP$now".gz
backupfolder="/tmp/DIRETORIO-BACKUP/"
fullpathbackupfile="$backupfolder/$filename"
logfile="$backupfolder/"backup_log_"$(date +'%Y_%m')".txt
#
#
#
#Inicio do backup
#
echo "backup do MySql iniciado as $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
mysqldump --user=nomedousuariosql --password=senhadousuariomysql --default-character-set=utf8 nomedobanco | gzip > "$fullpathbackupfile"
echo "backup do MySql finalizado as $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
#
#Alterando permissões
#
chown root "$fullpathbackupfile"
chown root "$logfile"
echo "alterando permissões..." >> "$logfile"
#
#Deletando arquivos com mais de 8 dias
#
find "$backupfolder" -name nomedoarquivoBKP* -mtime +8 -exec rm {} \;
echo "deletando arquivos antigos do backup" >> "$logfile"
echo "backup finalizado as $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
echo "*****************" >> "$logfile"
#
#
#Upload dos arquivos para o bucket criado na AWS
#
echo "subindo arquivos para a S3... iniciado as $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
aws s3 sync /tmp/DIRETORIO-BACKUP s3://nomedobucket-S3
echo "Upload concluido as $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
echo "*****************" >> "$logfile"
#
#
#Envio do arquivo de log anexado, utilizando o sendmail + uuencode
#
uuencode "$logfile" bkp_log.txt | sendmail -v "TITULO EMAIL" seu_email@destinatario.com
exit