
resource "google_compute_global_address" "address_1" {
  name = "address-1"
}
# forwarding rule
resource "google_compute_global_forwarding_rule" "f1" {
  name                  = "f1"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.http_proxy_1.id
  ip_address            = google_compute_global_address.address_1.id
}

# http proxy
resource "google_compute_target_http_proxy" "http_proxy_1" {
  name     = "http-proxy-1"
  url_map  = google_compute_url_map.lb_1.id
}

# url map
resource "google_compute_url_map" "lb_1" {
  name            = "lb-1"
  default_service = google_compute_backend_service.backend_1.id
}

# backend service with custom request and response headers
resource "google_compute_backend_service" "backend_1" {
  name                     = "backend-service-1"
  protocol                 = "HTTP"
  port_name                = "http"
  load_balancing_scheme    = "EXTERNAL"
  timeout_sec              = 10
  health_checks            = [google_compute_health_check.health_check_1.id]
  security_policy = google_compute_security_policy.armor_policy_1.id
  backend {
    group           = google_compute_instance_group_manager.instance_group_manager_1.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
    max_utilization = "0.8"
  }
}


resource "google_compute_instance_template" "instance_template_1" {
  name_prefix  = "instance-template-1"
  machine_type = "f1-micro"
  region       = "us-central1"
depends_on = [
  google_compute_subnetwork.vpc1-sub1
]
  
  tags=["template1"]

  disk {
          source_image      = "debian-cloud/debian-9"
    auto_delete       = true
    boot              = true
  }

  network_interface {
  
    network = "vpc1"
    subnetwork="vpc1-sub1"
   
 
  }
  
         metadata_startup_script = <<-EOT
                  #!/bin/bash

                  sudo apt-get update && sudo apt -y install apache2

                  echo "Hi from $HOSTNAME" >  /var/www/html/index.html
        EOT


  lifecycle {
    create_before_destroy = true
  }
}


resource "google_compute_instance_group_manager" "instance_group_manager_1" {
  name               = "instance-group-manager-1"
  version{
  instance_template  = google_compute_instance_template.instance_template_1.id
  }
  depends_on = [
    google_compute_instance_template.instance_template_1
  ]
  base_instance_name = "instance-group-1"
  zone               = "us-central1-a"
   named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.health_check_1.id
    initial_delay_sec = 300
  }
  
  
  

}
resource "google_compute_autoscaler" "autoscaler_1" {
  name   = "autoscaler-1"
  zone   = "us-central1-a"
  target = google_compute_instance_group_manager.instance_group_manager_1.id

     depends_on = [
    google_compute_instance_group_manager.instance_group_manager_1
  ]

  autoscaling_policy {
    max_replicas    = 4
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.8
    }
  }
}

resource "google_compute_health_check" "health_check_1" {
  name = "health-check-1"

  timeout_sec        = 1
  check_interval_sec = 1

  tcp_health_check {
    port = "80"
  }
  
 
}


resource "google_compute_security_policy" "armor_policy_1" {
  name = "armor-policy-1"

  rule {
    action   = "deny(403)"
    priority = "1000"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["124.66.170.219"]
      }
    }
    description = "Deny access to IPs in 9.9.9.0/24"
  }

  rule {
    action   = "allow"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "default allow rule"
  }
}
