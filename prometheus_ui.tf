

## Aplicar todos os manifestos no cluster

resource "kubernetes_manifest" "prometheus-ui" {
  manifest = yamldecode(file("${path.module}/prometheus/prometheus-ui.yaml"))
}


resource "kubernetes_manifest" "velero" {
  manifest = yamldecode(file("${path.module}/prometheus/velero_prometheus.yaml"))
}


resource "kubernetes_manifest" "velero" {
  manifest = yamldecode(file("${path.module}/prometheus/velero_alerts.yaml"))
}


resource "kubernetes_manifest" "velero" {
  manifest = yamldecode(file("${path.module}/prometheus/node_exporter.yaml"))
}


resource "kubernetes_manifest" "velero" {
  manifest = yamldecode(file("${path.module}/prometheus/node_exporter_rules.yaml"))
}


resource "kubernetes_manifest" "velero" {
  manifest = yamldecode(file("${path.module}/prometheus/kube_metrics.yaml"))
}

resource "kubernetes_manifest" "velero" {
  manifest = yamldecode(file("${path.module}/prometheus/kube_metrics_alerts.yaml"))
}

