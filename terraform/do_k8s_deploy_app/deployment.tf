resource "digitalocean_kubernetes_cluster" "k8s_cluster" {
  name   = var.cluster_name
  region = "nyc3"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = var.do_k8s_slug_ver

  node_pool {
    name       = var.cluster_name
    size       = "s-1vcpu-2gb"
    node_count = 2
    auto_scale = true
    min_nodes  = 2
    max_nodes  = 3
    tags       = [var.cluster_name]
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name = var.cluster_name
  }
  spec {
    selector = {
      app = kubernetes_deployment.app.metadata.0.labels.app
    }
    port {
      port        = 80
      target_port = 5000
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_deployment" "app" {
  metadata {
    name = var.cluster_name
    labels = {
      app = var.cluster_name
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = var.cluster_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.cluster_name
        }
      }

      spec {
        container {
          image = var.docker_image
          name  = var.cluster_name
          port {
            name           = "port-5000"
            container_port = 5000
          }
        }
      }
    }
  }
}