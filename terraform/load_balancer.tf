resource "yandex_alb_target_group" "lb_target_group" {
  name = "target-group"

  target {
    subnet_id  = yandex_vpc_subnet.default.id
    ip_address = yandex_compute_instance.vm["instance-1"].network_interface.0.ip_address
  }
  target {
    subnet_id  = yandex_vpc_subnet.default.id
    ip_address = yandex_compute_instance.vm["instance-2"].network_interface.0.ip_address
  }
}

resource "yandex_alb_http_router" "lb-router" {
  name = "http-router"
}

resource "yandex_alb_load_balancer" "balancer" {
  name       = "load-balancer"
  network_id = yandex_vpc_network.default.id
  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.default.id
    }
  }

  listener {
    name = "listener-http"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.lb-router.id
      }
    }
  }

  listener {
    name = "listener-https"
    endpoint {
      ports = [443]
      address {
        external_ipv4_address {
        }
      }
    }

    tls {
      default_handler {
        certificate_ids = ["${var.certificate_id}"]

        http_handler {
          http_router_id = yandex_alb_http_router.lb-router.id
        }
      }
    }
  }
}

resource "yandex_alb_virtual_host" "virtual-host" {
  name           = "virtual-host"
  http_router_id = yandex_alb_http_router.lb-router.id
  route {
    name = "route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.backend-group.id
      }
    }
  }
}

resource "yandex_alb_backend_group" "backend-group" {
  name = "backend-group"

  http_backend {
    name             = "http-backend"
    weight           = 1
    port             = 80
    target_group_ids = [yandex_alb_target_group.lb_target_group.id]
    healthcheck {
      timeout  = "1s"
      interval = "1s"
      http_healthcheck {
        path = "/ping"
      }
    }
  }
}
