resource "google_monitoring_alert_policy" "KubePodCrashLooping" {
  display_name = "KubePodCrashLooping -- Value: {{metric.label.value}}"
  combiner     = "OR"

  conditions {
    display_name = "KubePodCrashLooping -"
    condition_prometheus_query_language {
      query               = "rate(kube_pod_container_status_restarts_total{job=\"kube-state-metrics\"}[15m]) * 60 * 5 > 0"
      duration            = "60s"
      evaluation_interval = "3600s"
    }
  }

  documentation {
    content   = "Pod is restarting for 5 minutes. Current value"
    mime_type = "text/markdown"
  }

  notification_channels = [google_monitoring_notification_channel.email_channel.id]

  severity = "CRITICAL"

  alert_strategy {
    auto_close = "86400s"
  }
}


# --


resource "google_monitoring_alert_policy" "KubePodNotReady" {
  display_name = "KubePodNotReady -- "
  combiner     = "OR"

  conditions {
    display_name = "KubePodNotReady -- "
    condition_prometheus_query_language {
      query               = "sum by (namespace, pod) (kube_pod_status_ready{job=\"kube-state-metrics\", condition=\"false\"}) > 0"
      duration            = "3600s" # 1 hour duration
      evaluation_interval = "60s"   # 1 minute evaluation interval
    }
  }

  documentation {
    content   = "Pod has been in a non-ready state for longer than an hour. See runbook for details: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubepodnotready"
    mime_type = "text/markdown"
  }

  notification_channels = [google_monitoring_notification_channel.email_channel.id]

  severity = "CRITICAL"

  alert_strategy {
    auto_close = "86400s" # 1 day
  }
}


resource "google_monitoring_alert_policy" "KubeDeploymentGenerationMismatch" {
  display_name = "KubeDeploymentGenerationMismatch -- "
  combiner     = "OR"

  conditions {
    display_name = "KubeDeploymentGenerationMismatch -- "
    condition_prometheus_query_language {
      query               = "sum by (namespace, deployment) (kube_deployment_status_replicas_unavailable{job=\"kube-state-metrics\"} > 0)"
      duration            = "900s" # 15 minutes duration
      evaluation_interval = "60s"  # 1 minute evaluation interval
    }
  }

  documentation {
    content   = "Deployment generation does not match, this indicates that the Deployment has failed but has not been rolled back. See runbook for details: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubedeploymentgenerationmismatch"
    mime_type = "text/markdown"
  }

  notification_channels = [google_monitoring_notification_channel.email_channel.id]

  severity = "CRITICAL"

  alert_strategy {
    auto_close = "86400s" # 1 day
  }
}


resource "google_monitoring_alert_policy" "KubeDeploymentReplicasMismatch" {
  display_name = "KubeDeploymentReplicasMismatch -- "
  combiner     = "OR"

  conditions {
    display_name = "KubeDeploymentReplicasMismatch -- "
    condition_prometheus_query_language {
      query               = "kube_deployment_spec_replicas{job=\"kube-state-metrics\"} != kube_deployment_status_replicas_available{job=\"kube-state-metrics\"}"
      duration            = "3600s" # 1 hour duration
      evaluation_interval = "60s"   # 1 minute evaluation interval
    }
  }

  documentation {
    content   = "Deployment has not matched the expected number of replicas for longer than an hour. See runbook for details: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubedeploymentreplicasmismatch"
    mime_type = "text/markdown"
  }

  notification_channels = [google_monitoring_notification_channel.email_channel.id]

  severity = "CRITICAL"

  alert_strategy {
    auto_close = "86400s" # 1 day
  }
}


resource "google_monitoring_alert_policy" "KubeStatefulSetReplicasMismatch" {
  display_name = "KubeStatefulSetReplicasMismatch -- "
  combiner     = "OR"

  conditions {
    display_name = "KubeStatefulSetReplicasMismatch -- "
    condition_prometheus_query_language {
      query               = "kube_statefulset_status_replicas_ready{job=\"kube-state-metrics\"} != kube_statefulset_status_replicas{job=\"kube-state-metrics\"}"
      duration            = "900s" # 15 minutes duration
      evaluation_interval = "60s"  # 1 minute evaluation interval
    }
  }

  documentation {
    content   = "StatefulSet has not matched the expected number of replicas for longer than 15 minutes. See runbook for details: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubestatefulsetreplicasmismatch"
    mime_type = "text/markdown"
  }

  notification_channels = [google_monitoring_notification_channel.email_channel.id]

  severity = "CRITICAL"

  alert_strategy {
    auto_close = "86400s" # 24 hours auto-close duration
  }
}


resource "google_monitoring_alert_policy" "KubeStatefulSetGenerationMismatch" {
  display_name = "KubeStatefulSetGenerationMismatch -- "
  combiner     = "OR"

  conditions {
    display_name = "KubeStatefulSetGenerationMismatch -- "
    condition_prometheus_query_language {
      query               = "kube_statefulset_status_observed_generation{job=\"kube-state-metrics\"} != kube_statefulset_metadata_generation{job=\"kube-state-metrics\"}"
      duration            = "900s" # 15 minutes duration
      evaluation_interval = "60s"  # 1 minute evaluation interval
    }
  }

  documentation {
    content   = "StatefulSet generation does not match, this indicates that the StatefulSet has failed but has not been rolled back. See runbook for details: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubestatefulsetgenerationmismatch"
    mime_type = "text/markdown"
  }

  notification_channels = [google_monitoring_notification_channel.email_channel.id]

  severity = "CRITICAL"

  alert_strategy {
    auto_close = "86400s" # 24 hours auto-close duration
  }
}


resource "google_monitoring_alert_policy" "KubeStatefulSetUpdateNotRolledOut" {
  display_name = "KubeStatefulSetUpdateNotRolledOut -- "
  combiner     = "OR"

  conditions {
    display_name = "KubeStatefulSetUpdateNotRolledOut -- "
    condition_prometheus_query_language {
      query               = "max without (revision) (kube_statefulset_status_current_revision{job=\"kube-state-metrics\"} unless kube_statefulset_status_update_revision{job=\"kube-state-metrics\"}) * (kube_statefulset_replicas{job=\"kube-state-metrics\"} != kube_statefulset_status_replicas_updated{job=\"kube-state-metrics\"})"
      duration            = "900s" # 15 minutes duration
      evaluation_interval = "60s"  # 1 minute evaluation interval
    }
  }

  documentation {
    content   = "StatefulSet update has not been rolled out. See runbook for details: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubestatefulsetupdatenotrolledout"
    mime_type = "text/markdown"
  }

  notification_channels = [google_monitoring_notification_channel.email_channel.id]

  severity = "CRITICAL"

  alert_strategy {
    auto_close = "86400s" # 24 hours auto-close duration
  }
}


resource "google_monitoring_alert_policy" "KubeDaemonSetRolloutStuck" {
  display_name = "KubeDaemonSetRolloutStuck -- "
  combiner     = "OR"

  conditions {
    display_name = "KubeDaemonSetRolloutStuck -- "
    condition_prometheus_query_language {
      query               = "kube_daemonset_status_number_ready{job=\"kube-state-metrics\"} / kube_daemonset_status_desired_number_scheduled{job=\"kube-state-metrics\"} * 100 < 100"
      duration            = "900s" # 15 minutes duration
      evaluation_interval = "60s"  # 1 minute evaluation interval
    }
  }

  documentation {
    content   = "Only of half the desired Pods of DaemonSet are scheduled and ready. See runbook for details: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubedaemonsetrolloutstuck"
    mime_type = "text/markdown"
  }

  notification_channels = [google_monitoring_notification_channel.email_channel.id]

  severity = "CRITICAL"

  alert_strategy {
    auto_close = "86400s" # 24 hours auto-close duration
  }
}

resource "google_monitoring_alert_policy" "KubeDaemonSetNotScheduled" {
  display_name = "KubeDaemonSetNotScheduled -- "
  combiner     = "OR"

  conditions {
    display_name = "KubeDaemonSetNotScheduled -- "
    condition_prometheus_query_language {
      query               = "kube_daemonset_status_desired_number_scheduled{job=\"kube-state-metrics\"} - kube_daemonset_status_current_number_scheduled{job=\"kube-state-metrics\"} > 0"
      duration            = "600s" # 10 minutes duration
      evaluation_interval = "60s"  # 1 minute evaluation interval
    }
  }

  documentation {
    content   = " Pods of DaemonSet  are not scheduled. See runbook for details: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubedaemonsetnotscheduled"
    mime_type = "text/markdown"
  }

  notification_channels = [google_monitoring_notification_channel.email_channel.id]

  severity = "WARNING"

  alert_strategy {
    auto_close = "86400s" # 24 hours auto-close duration
  }
}

resource "google_monitoring_alert_policy" "KubeDaemonSetMisScheduled" {
  display_name = "KubeDaemonSetMisScheduled -- "
  combiner     = "OR"

  conditions {
    display_name = "KubeDaemonSetMisScheduled -- "
    condition_prometheus_query_language {
      query               = "kube_daemonset_status_number_misscheduled{job=\"kube-state-metrics\"} > 0"
      duration            = "600s" # 10 minutes duration
      evaluation_interval = "60s"  # 1 minute evaluation interval
    }
  }

  documentation {
    content   = "Pods of DaemonSet are running where they are not supposed to run. See runbook for details: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubedaemonsetmisscheduled"
    mime_type = "text/markdown"
  }

  notification_channels = [google_monitoring_notification_channel.email_channel.id]

  severity = "WARNING"

  alert_strategy {
    auto_close = "86400s" # 24 hours auto-close duration
  }
}


resource "google_monitoring_alert_policy" "KubeJobFailed" {
  display_name = "KubeJobFailed -- "
  combiner     = "OR"

  conditions {
    display_name = "KubeJobFailed Condition -- "
    condition_prometheus_query_language {
      query               = "kube_job_status_failed{job=\"kube-state-metrics\"} > 0"
      duration            = "3600s" # 1 hour duration
      evaluation_interval = "60s"   # 1 minute evaluation interval
    }
  }

  documentation {
    content   = "Job failed to complete. See runbook for details: https://github.com/kubernetes-monitoring/kubernetes-mixin/tree/master/runbook.md#alert-name-kubejobfailed"
    mime_type = "text/markdown"
  }

  notification_channels = [google_monitoring_notification_channel.email_channel.id]

  severity = "WARNING"

  alert_strategy {
    auto_close = "86400s" # 24 hours auto-close duration
  }
}

resource "google_monitoring_alert_policy" "cpu_throttling_25_percent" {
  display_name = "CPU Throttling > 25% -- "
  combiner     = "OR"

  conditions {
    display_name = "CPU Throttling 25% Condition -- "
    condition_prometheus_query_language {
      query               = "rate(container_cpu_cfs_throttled_seconds_total[1m40s]) >= 25"
      evaluation_interval = "60s" # 1 minute evaluation interval
    }
  }

  documentation {
    content   = "Pod  CPU throttling is more than 25%."
    mime_type = "text/markdown"
  }

  notification_channels = [google_monitoring_notification_channel.email_channel.id]

  severity = "CRITICAL"

  alert_strategy {
    auto_close = "86400s" # 24 hours auto-close duration
  }
}


resource "google_monitoring_alert_policy" "PodOutOfMemory10Percent" {
  display_name = "Pod Out Of Memory < 10% -- "
  combiner     = "OR"

  conditions {
    display_name = "Pod Out Of Memory < 10% Condition -- "
    condition_prometheus_query_language {
      query               = "(sum by(cluster, namespace, pod, container, name) (container_memory_working_set_bytes{name!=\"\"}) / sum by(cluster, namespace, pod, container, name) (container_spec_memory_limit_bytes > 0) * 100) > 90"
      duration            = "300s" # 5 minutes duration
      evaluation_interval = "60s"  # 1 minute evaluation interval
    }
  }

  documentation {
    content   = "Pod is running out of memory. Less than 10% left."
    mime_type = "text/markdown"
  }

  notification_channels = [google_monitoring_notification_channel.email_channel.id]

  severity = "WARNING"

  alert_strategy {
    auto_close = "86400s" # 24 hours auto-close duration
  }
}



resource "google_monitoring_alert_policy" "PodOutOfMemory5Percent" {
  display_name = "Pod Out Of Memory < 5% -- "
  combiner     = "OR"

  conditions {
    display_name = "Pod Out Of Memory < 5% Condition -- "
    condition_prometheus_query_language {
      query               = "(sum by(cluster, namespace, pod, container, name) (container_memory_working_set_bytes{name!=\"\"}) / sum by(cluster, namespace, pod, container, name) (container_spec_memory_limit_bytes > 0) * 100) > 95"
      duration            = "300s" # 5 minutes duration
      evaluation_interval = "60s"  # 1 minute evaluation interval
    }
  }

  documentation {
    content   = "Pod is running out of memory. Less than 5% left."
    mime_type = "text/markdown"
  }

  notification_channels = [google_monitoring_notification_channel.email_channel.id]

  severity = "CRITICAL"

  alert_strategy {
    auto_close = "86400s" # 24 hours auto-close duration
  }
}


resource "google_monitoring_alert_policy" "PodStuckPending" {
  display_name = "Pod Stuck Pending -- "
  combiner     = "OR"

  conditions {
    display_name = "Pod Stuck Pending Condition -- "
    condition_prometheus_query_language {
      query               = "sum by(cluster, namespace, pod) (sum_over_time(kube_pod_status_phase{phase=\"Pending\"}[15m]) / 10) >= 0.8"
      evaluation_interval = "60s" # 1 minute evaluation interval
    }
  }

  documentation {
    content   = "Pod  stuck in pending state."
    mime_type = "text/markdown"
  }

  notification_channels = [google_monitoring_notification_channel.email_channel.id]

  severity = "WARNING"

  alert_strategy {
    auto_close = "86400s" # 24 hours auto-close duration
  }
}


resource "google_monitoring_alert_policy" "cpu_throttling_5_percent" {
  display_name = "CPU Throttling > 5% -- "
  combiner     = "OR"

  conditions {
    display_name = "CPU Throttling 5% Condition -- "
    condition_prometheus_query_language {
      query               = "rate(container_cpu_cfs_throttled_seconds_total[1m40s]) >= 5"
      evaluation_interval = "60s" # 1 minute evaluation interval
    }
  }

  documentation {
    content   = "Pod  CPU throttling is more than 5%."
    mime_type = "text/markdown"
  }

  notification_channels = [google_monitoring_notification_channel.email_channel.id]

  severity = "WARNING"

  alert_strategy {
    auto_close = "86400s" # 24 hours auto-close duration
  }
}



resource "google_monitoring_alert_policy" "cpu_throttling_10_percent" {
  display_name = "CPU Throttling > 10% -- "
  combiner     = "OR"

  conditions {
    display_name = "CPU Throttling 10% Condition -- "
    condition_prometheus_query_language {
      query               = "rate(container_cpu_cfs_throttled_seconds_total[1m40s]) >= 10"
      evaluation_interval = "60s" # 1 minute evaluation interval
    }
  }

  documentation {
    content   = "Pod CPU throttling is more than 10%."
    mime_type = "text/markdown"
  }

  notification_channels = [google_monitoring_notification_channel.email_channel.id]

  severity = "WARNING"

  alert_strategy {
    auto_close = "86400s" # 24 hours auto-close duration
  }
}



resource "google_monitoring_alert_policy" "PodRestart10" {
  display_name = "Pod Restart > 10 in 10 Minutes -- "
  combiner     = "OR"

  conditions {
    display_name = "Pod Restart 10 Condition -- "
    condition_prometheus_query_language {
      query               = "increase(kube_pod_container_status_restarts_total[10m]) > 10"
      evaluation_interval = "60s" # 1 minute evaluation interval
    }
  }

  documentation {
    content   = "Pod  has been restarted > 10 times in 10 minutes."
    mime_type = "text/markdown"
  }

  notification_channels = [google_monitoring_notification_channel.email_channel.id]

  severity = "CRITICAL"

  alert_strategy {
    auto_close = "86400s" # 24 hours auto-close duration
  }
}


resource "google_monitoring_alert_policy" "PodCrashLooping" {
  display_name = "Pod Crash Looping -- "
  combiner     = "OR"

  conditions {
    display_name = "Pod Crash Looping Condition -- "
    condition_prometheus_query_language {
      query               = "sum by(cluster, namespace, pod) (sum_over_time(kube_pod_container_status_waiting_reason{reason=\"CrashLoopBackOff\"}[15m]) / 10) >= 0.8"
      evaluation_interval = "60s" # 1 minute evaluation interval
    }
  }

  documentation {
    content   = "Pod is crash looping."
    mime_type = "text/markdown"
  }

  notification_channels = [google_monitoring_notification_channel.email_channel.id]

  severity = "CRITICAL"

  alert_strategy {
    auto_close = "86400s" # 24 hours auto-close duration
  }
}
