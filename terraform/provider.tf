terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.107.0"
    }
  }
}

provider "yandex" {
  zone      = "ru-central1-a"
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  token     = var.yc_token
}
