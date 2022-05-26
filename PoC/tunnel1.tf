resource "google_compute_vpn_gateway" "vpn_gateway_1" {
  name    = "vpn-gateway-1"
  network = google_compute_network.vpc1.id
  
}

resource "google_compute_vpn_tunnel" "tunnel1" {
  name          = "tunnel1"
  peer_ip       = google_compute_address.vpn_static_ip_2.address
  shared_secret = "a secret message"

  target_vpn_gateway = google_compute_vpn_gateway.vpn_gateway_1.id
   local_traffic_selector = ["0.0.0.0/0"]
  depends_on = [
    google_compute_forwarding_rule.fr_esp,
    google_compute_forwarding_rule.fr_udp500,
    google_compute_forwarding_rule.fr_udp4500,
  ]
}



resource "google_compute_address" "vpn_static_ip_1" {
  name = "static1"
}

resource "google_compute_forwarding_rule" "fr_esp" {
  name        = "fr-esp"
  ip_protocol = "ESP"
 
  ip_address  = google_compute_address.vpn_static_ip_1.address
  target      = google_compute_vpn_gateway.vpn_gateway_1.id
}

resource "google_compute_forwarding_rule" "fr_udp500" {
  name        = "fr-udp500"
  ip_protocol = "UDP"
  port_range  = "500"

  ip_address  = google_compute_address.vpn_static_ip_1.address
  target      = google_compute_vpn_gateway.vpn_gateway_1.id
}

resource "google_compute_forwarding_rule" "fr_udp4500" {
  name        = "fr-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500"
 
  ip_address  = google_compute_address.vpn_static_ip_1.address
  target      = google_compute_vpn_gateway.vpn_gateway_1.id
}
