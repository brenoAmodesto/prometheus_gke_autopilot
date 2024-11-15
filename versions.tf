terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}


provider "google" {
  project     = "seuprojeto"
  region      = "us-east1"
  credentials = # suas credenciais
}

provider "kubernetes" {
  config_path = "~/.kube/config" # Ajuste para o caminho correto do seu kubeconfig
}
