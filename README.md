
# Configuração do Velero e Prometheus Gerenciado no GKE Autopilot


## ---

Este repositório contém os arquivos e configurações necessários para configurar o Velero para backups e o Prometheus Gerenciado no Google Kubernetes Engine (GKE) Autopilot. Também inclui a configuração de alertas via Terraform para envio de notificações utilizando o Google Cloud Monitoring (GCM).


### Pré-Requisitos

- Conta no Google Cloud Platform (GCP)
- Kubectl e gcloud CLI instalados e configurados.
- Configuração básica de Terraform para gerenciar recursos na GCP.


### Configuração de Variáveis

As variáveis estão definidas nos arquivos variables.tf e terraform.tfvars. Certifique-se de ajustar as seguintes variáveis em terraform.tfvars conforme o seu ambiente:

- project_id: ID do projeto no Google Cloud.
- service_account_email: E-mail da conta de serviço utilizada.
- bucket_name: Nome do bucket do Velero.
- alert_email_address: Endereço de e-mail para receber alertas do Prometheus.

## Exemplo de configuração no tfvars:

        project_id           = "seu-projeto-id"
        service_account_email  "sua-service-account-email"
        bucket_name          = "seu-nome-do-bucket"
        alert_email_address  = "seu-email@exemplo.com"

## O Terraform irá:

Antes de  aplicar a configuração, altere o Project ID no manifesto prometheus_ui

        terraform init && terraform apply

- Criar as contas de serviço para o Velero e Prometheus.
- Configurar o bucket do Velero.
- Aplicar os manifestos necessários para o Prometheus Gerenciado.
- Configurar o canal de alerta e os alertas no GCM para envio de notificações por e-mail.