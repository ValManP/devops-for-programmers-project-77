resource "datadog_monitor" "health-check" {
  name    = "health check"
  type    = "service check"
  query   = "\"http.can_connect\".over(\"instance:datadog_health_check\").by(\"host\",\"instance\",\"url\").last(2).count_by_status()"
  message = "{{host.name}} is not available"
}
