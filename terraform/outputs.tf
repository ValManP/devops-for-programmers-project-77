resource "local_file" "ansible-env" {
  content = templatefile("templates/.env.tftpl", {
    redmine_db_host     = yandex_mdb_postgresql_cluster.cluster.id
    redmine_db_username = var.db_user
    redmine_db_password = var.db_password
    redmine_db_database = var.db_name
    redmine_db_port     = 6432
    datadog_api_key     = var.datadog_api_key
    datadog_app_key     = var.datadog_app_key
  })
  filename = "../ansible/.env"
}

resource "local_file" "ansible-inventory" {
  content = templatefile("templates/inventory.tftpl", {
    server1 = yandex_compute_instance.vm["instance-1"].network_interface.0.nat_ip_address
    server2 = yandex_compute_instance.vm["instance-2"].network_interface.0.nat_ip_address
  })
  filename = "../ansible/inventory.ini"
}
