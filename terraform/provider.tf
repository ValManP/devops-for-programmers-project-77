terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.107.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.4.1"
    }
    datadog = {
      source = "DataDog/datadog"
      version = "3.36.1"
    }
  }
}

provider "yandex" {
  zone      = "ru-central1-a"
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  token     = var.yc_token
}

provider "local" {}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = "https://api.us5.datadoghq.com/"
}
