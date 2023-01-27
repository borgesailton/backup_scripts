# PowerShell Script para automação de backup para bucket na AWS S3
# utilizando AWS Tools for PowerShell
#
# Escrito por: Ailton Borges
#
$folderPath = "C:\exemplo\pasta1" #caminho da pasta a ser backupada
$bucketName = "bucket-destino" #nome do bucket S3
$logFile = "C:\backup-log.txt" #caminho do arquivo de log

# Importar o módulo AWS
Import-Module AWS.Tools.Common

# Configurar as credenciais da AWS
Set-AWSCredentials -AccessKey "AKIAIOSFODNN7EXAMPLE" -SecretKey "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY" -StoreAs "default"

# Fazer backup da pasta para o S3
$startTime = Get-Date
Add-S3Object -BucketName $bucketName -Folder $folderPath -Recurse -Force
$endTime = Get-Date

# Escrever a hora de início e fim do backup no arquivo de log
"Backup iniciado em: $startTime" | Out-File -FilePath $logFile -Append
"Backup concluído em: $endTime" | Out-File -FilePath $logFile -Append
