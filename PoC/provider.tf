provider "google"{
    credentials=file("terra_auth.json")
     project = "${var.gcp_project}"
    region  = "${var.region}"
    }

//creating service-account-1
resource "google_service_account" "service-account-1" {
display_name = "account1"
account_id   = "account-1"

}
/*
//adding compute admin role to created serviceaccount1
resource "google_project_iam_member"  "gce-default-account-iam"{
    project="${var.gcp_project}"
    role    = "roles/compute.admin"
    member  = "serviceAccount:${google_service_account.service-account-1.email}"
    }

*/

