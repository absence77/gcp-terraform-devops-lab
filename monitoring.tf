resource "google_monitoring_notification_channel" "email_channel" {
  display_name = "Email Notifications"
  type         = "email"

  labels = {
    email_address = "ahmad.gayibov@gmail.com"
  }
}




resource "google_monitoring_alert_policy" "high_cpu_alert" {
  display_name          = "High CPU Alert"
  notification_channels = [google_monitoring_notification_channel.email_channel.id]
  combiner              = "AND" # Добавляем аргумент combiner для комбинирования условий

  conditions {
    display_name = "High CPU Utilization"
    condition_threshold {
      comparison      = "COMPARISON_GT"
      threshold_value = 80
      duration        = "60s"
      filter          = "resource.type=\"gce_instance\" AND metric.type=\"compute.googleapis.com/instance/disk/write_bytes_count\""

      # Добавляем агрегацию
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }
}

