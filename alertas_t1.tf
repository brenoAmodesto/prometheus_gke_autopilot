resource "google_monitoring_alert_policy" "alert_policy" {
  display_name = "HostOutOfMemory"
  combiner     = "OR"
  conditions {
    display_name = "HostOutOfMemory"
    condition_prometheus_query_language {
      query               = "node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100 < 10"
      duration            = "60s"
      evaluation_interval = "300s"
      alert_rule          = "AlwaysOn"
    }
  }

  notification_channels = [google_monitoring_notification_channel.email_channel.id]

  severity = "CRITICAL"

  alert_strategy {
    auto_close = "86400s" # 1 day
  }
}


resource "google_monitoring_notification_channel" "email_channel" {
  display_name = "Canal para alertas prometheus"
  type         = "email"
  labels = {
    email_address = var.alert_email_address
  }
}
