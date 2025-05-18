// Create an email notification channel for Google Cloud Monitoring alerts
resource "google_monitoring_notification_channel" "email_channel" {
  display_name = "Email Notifications"
  type         = "email"

  labels = {
    email_address = "ahmad.gayibov@gmail.com"
  }
}

// Create an alerting policy for high CPU utilization on GCE instances
resource "google_monitoring_alert_policy" "high_cpu_alert" {
  display_name          = "High CPU Alert"
  notification_channels = [google_monitoring_notification_channel.email_channel.id]
  combiner              = "AND" // Combine conditions using AND operator

  conditions {
    display_name = "High CPU Utilization"
    condition_threshold {
      comparison      = "COMPARISON_GT"
      threshold_value = 80
      duration        = "60s"
      // NOTE: The metric below is currently for disk write bytes, should be changed to CPU utilization if desired
      filter = "resource.type=\"gce_instance\" AND metric.type=\"compute.googleapis.com/instance/disk/write_bytes_count\""

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }
}

