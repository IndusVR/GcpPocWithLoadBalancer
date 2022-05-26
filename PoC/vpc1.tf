
resource "google_compute_network" "vpc1" {
  name = "vpc1"
  auto_create_subnetworks="false"

}
resource google_compute_subnetwork "vpc1-sub1"{
name="vpc1-sub1"
region="us-central1"
network = "vpc1"
depends_on = [google_compute_network.vpc1]
ip_cidr_range = "10.1.1.0/24"
}

resource google_compute_subnetwork "vpc1-sub2"{
name="vpc1-sub2"
region="us-west1"
network = "vpc1"
depends_on = [google_compute_network.vpc1]
ip_cidr_range = "10.2.2.0/24"
}
