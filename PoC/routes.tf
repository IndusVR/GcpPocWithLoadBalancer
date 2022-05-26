
resource "google_compute_route" "route1-a" {
  name       = "route1-a"
  description = "Custom route from vpc1 to vpc2(vm-1 to db-1)"
  network    = google_compute_network.vpc1.name
  tags=["template1"]
  dest_range = "10.3.3.2"
  priority   = 1000

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel1.id
}

resource "google_compute_route" "route1-b" {
  name       = "route1-b"
  description = "Custom route from vpc1 to vpc2(vm-2 to db-2)"
  network    = google_compute_network.vpc1.name
  tags=["template2"]
  dest_range = "10.4.4.2"
  
  priority   = 1000

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel1.id
}


resource "google_compute_route" "route2-a" {
  name       = "route2-a"
   description = "Custom route from vpc2 to vpc1(db-1 to vm-1)"
  network    = google_compute_network.vpc2.name
  tags = ["db1"]
  dest_range = "10.1.1.0/24"
  priority   = 1000

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel2.id
}


resource "google_compute_route" "route2-b" {
  name       = "route2-b"
   description = "Custom route from vpc2 to vpc1(db-2 to vm-2)"
  network    = google_compute_network.vpc2.name
  tags=["db2"]
  dest_range = "10.2.2.0/24"
  priority   = 1000

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel2.id
}
