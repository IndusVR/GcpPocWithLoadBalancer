

resource "google_compute_address" "DB_1" {
  name         = "db-1-internal-ip"
  subnetwork   = google_compute_subnetwork.vpc2-sub1.id
  address_type = "INTERNAL"
  address      = "10.3.3.2"
  region       = "asia-east1"
  
}

resource "google_compute_address" "DB_2" {
  name         = "db-2-internal-ip"
  subnetwork   = google_compute_subnetwork.vpc2-sub2.id
  address_type = "INTERNAL"
  address      = "10.4.4.2"
  region       = "asia-south2"
  
}


resource "google_compute_instance" "db_1" {
  name         = "vpc2-db1"
  
   zone="asia-east1-b"
   machine_type = "f1-micro"
  tags=["db1"]
  depends_on = [
    google_compute_subnetwork.vpc2-sub1
  ]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
  
    network = "vpc2"
    subnetwork="vpc2-sub1"
    network_ip =google_compute_address.DB_1.address
   
  }


  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.service-account-1.email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "db_2" {
  name         = "vpc2-db2"
  
   zone="asia-south2-a"
   machine_type = "f1-micro"
  tags=["db2"]

    depends_on = [
    google_compute_subnetwork.vpc2-sub2
  ]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
  
    network = "vpc2"
    subnetwork="vpc2-sub2"
    network_ip =google_compute_address.DB_2.address
   
  }
 

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.service-account-1.email
    scopes = ["cloud-platform"]
  }
}