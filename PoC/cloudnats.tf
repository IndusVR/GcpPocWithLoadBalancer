

resource "google_compute_router" "router_1" {
  name    = "router-1"
  region  = google_compute_subnetwork.vpc1-sub1.region
  network = google_compute_network.vpc1.id

  bgp {
    asn = 64514
  }
}


resource "google_compute_router_nat" "nat_1" {
  name                               = "nat-1"
  router                             = google_compute_router.router_1.name
   region                             = google_compute_router.router_1.region
   nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.vpc1-sub1.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}


resource "google_compute_router" "router_2" {
  name    = "router-2"
  region  = google_compute_subnetwork.vpc1-sub2.region
  network = google_compute_network.vpc1.id

  bgp {
    asn = 64515
  }
}

resource "google_compute_router_nat" "nat_2" {
  name                               = "nat-2"
  router                             = google_compute_router.router_2.name
  region                             = google_compute_router.router_2.region
   nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.vpc1-sub2.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

}