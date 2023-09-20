provider "google" {
    credentials = file("your-credential.json")
    project     = "your-project-name"
    region      = "us-west2"
}