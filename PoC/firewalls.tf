
resource google_compute_firewall "allow-ingress-lbs"{
    name="all-ingress-lb"
    description = "Allow all ingress rules for vm1 & vm2 from any ip"
    network="${google_compute_network.vpc1.name}"
    depends_on = [google_compute_network.vpc1]
     direction = "INGRESS"
     source_ranges = ["0.0.0.0/0"]
     target_tags = ["template1","template2"]
     priority = 65534
     
  allow {
    protocol = "TCP"
    ports    = ["80","22"]
  }
   
}



resource google_compute_firewall "ingress-lb1-to-db1"{
    name="ingress-lb-to-db1"
    description = "Allow ingress to db-1 from vm-1 "
    network="${google_compute_network.vpc2.name}"
    depends_on = [google_compute_network.vpc2]

     direction = "INGRESS"
     source_ranges =["10.1.1.0/24"]
     target_tags = ["db1"]
     priority = 65534
   

  allow {
    protocol = "TCP"
    ports    = ["80","22"]
  }
    allow {
    protocol = "ICMP"
   
  }
    
}


resource google_compute_firewall "ingress-lb2-to-db2"{
    name="ingress-to-db2"
    description = "Allow ingress to db-2 from vm-1 "
    network="${google_compute_network.vpc2.name}"
    depends_on = [google_compute_network.vpc2]

     direction = "INGRESS"
     source_ranges =["10.2.2.0/24"]
     target_tags = ["db2"]
     priority = 65534
   

  allow {
    protocol = "TCP"
    ports    = ["80","22"]
  }
      allow {
    protocol = "ICMP"
   
  }
}
