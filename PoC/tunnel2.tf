resource "google_compute_vpn_gateway" "vpn_gateway_2" {
  name    = "vpn-gateway-2"
  network = google_compute_network.vpc2.id
 
}

resource "google_compute_vpn_tunnel" "tunnel2" {
  name          = "tunnel2"
  peer_ip       = google_compute_address.vpn_static_ip_1.address
  shared_secret = "a secret message"
  local_traffic_selector = ["0.0.0.0/0"]
  target_vpn_gateway = google_compute_vpn_gateway.vpn_gateway_2.id

  depends_on = [
    google_compute_forwarding_rule.fr_esp_2,
    google_compute_forwarding_rule.fr_udp500_2,
    google_compute_forwarding_rule.fr_udp4500_2,
  ]
}



resource "google_compute_address" "vpn_static_ip_2" {
  name = "static2"

}

resource "google_compute_forwarding_rule" "fr_esp_2" {
  name        = "fr-esp-2"
  ip_protocol = "ESP"
  ip_address  = google_compute_address.vpn_static_ip_2.address
  target  = google_compute_vpn_gateway.vpn_gateway_2.id

}

resource "google_compute_forwarding_rule" "fr_udp500_2" {
  name        = "fr-udp500-2"
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.vpn_static_ip_2.address
   target= google_compute_vpn_gateway.vpn_gateway_2.id

}

resource "google_compute_forwarding_rule" "fr_udp4500_2" {
  name        = "fr-udp4500-2"
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.vpn_static_ip_2.address
  target    = google_compute_vpn_gateway.vpn_gateway_2.id

}
