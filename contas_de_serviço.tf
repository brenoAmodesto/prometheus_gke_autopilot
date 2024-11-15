#Criação da Service Account no Google Cloud

resource "google_service_account" "prometheus_ui" {
   account_id   = "prometheusui"
   display_name = "Prometheus UI Service Account"
 }

# Associação da Policy de Workload Identity
resource "google_project_iam_binding" "prometheus_ui_workload_identity" {
   project = "ID_DO_PROJETO"
   role    = "roles/iam.workloadIdentityUser"

   members = [
     "serviceAccount:ID_DO_PROJETO.svc.id.goog[monitoring/default]"
   ]
 }

# Criação e anotação da Service Account no Kubernetes
resource "kubernetes_service_account" "default_monitoring" {
   metadata {
     name      = "default"
     namespace = "monitoring"
     annotations = {
       "iam.gke.io/gcp-service-account" = "${google_service_account.prometheus_ui.email}"
     }
   }
}

## Conta de serviço para o velero

resource "google_project_iam_custom_role" "velero_server" {
  role_id   = "velero_server"
  title     = "Velero Server"
  project   = var.project_id
  permissions = [
    # Adicione as permissões necessárias aqui
    # Por exemplo:
    "storage.objects.get",
    "storage.objects.list"
  ]
}


resource "google_project_iam_binding" "velero_server_binding" {
  project = var.project_id
  role    = "projects/${var.project_id}/roles/velero_server"

  members = [
    "serviceAccount:${var.service_account_email}"
  ]
}

resource "google_storage_bucket_iam_member" "velero_object_admin" {
  bucket = var.bucket_name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${var.service_account_email}"
}



