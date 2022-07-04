#
#
# PowerShell Script para backup de arquivos do File Server Windows para a AWS S3.
# Escrito por: Ailton Borges
#
# Declarando de Variaveis 
#
$logpath = Set-Location -Path D:\
$date = Get-Date -Format "MM-dd-yyyy HH:mm" | ForEach-Object {$_ -replace ":", "."}
# 
# Inicio do Backup..
#
Write-Output "Backup Iniciado as $date" >> "$logpath\log-$date.txt"
#
Write-Output "--------------------------------------------------" >> "$logpath\log-$date.txt"
#
# Sincronizando arquivos com o bucket S3 ...
#
aws s3 sync 'D:\' s3:// >> "$logpath\log-$date.txt"
#
Write-Output "--------------------------------------------------" >> "$logpath\log-$date.txt"
#
Write-Output "Backup Finalizado as $date" >> "$logpath\log-$date.txt"
#