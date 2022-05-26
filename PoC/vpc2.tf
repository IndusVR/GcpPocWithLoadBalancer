
resource "google_compute_network" "vpc2" {
  name = "vpc2"
  auto_create_subnetworks="false"
}
resource google_compute_subnetwork "vpc2-sub1"{
name="vpc2-sub1"
region="asia-east1"
network = "vpc2"
depends_on = [google_compute_network.vpc2]
ip_cidr_range = "10.3.3.0/24"
}

resource google_compute_subnetwork "vpc2-sub2"{
name="vpc2-sub2"
region="asia-south2"
network = "vpc2"
depends_on = [google_compute_network.vpc2]
ip_cidr_range = "10.4.4.0/24"
}
