resource "oci_load_balancer_load_balancer" "oci_homelab_load_balancer" {
  #Required
  compartment_id = var.compartment_ocid
  display_name   = "OCIHomeLabLoadBalancer"
  shape          = "flexible"
  shape_details {
    maximum_bandwidth_in_mbps = 10
    minimum_bandwidth_in_mbps = 10
  }

  subnet_ids = [
    oci_core_subnet.oci_homelab_subnet.id,
  ]
}

resource "oci_load_balancer_backend_set" "oci_homelab_load_balancer_backend_set" {
  name             = "lbBackendSet1"
  load_balancer_id = oci_load_balancer_load_balancer.oci_homelab_load_balancer.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = "80"
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/"
  }

  session_persistence_configuration {
    cookie_name      = "lb-session1"
    disable_fallback = true
  }
}

resource "oci_load_balancer_backend" "oci_homelab_load_balancer_test_backend0" {
  #Required
  backendset_name  = oci_load_balancer_backend_set.oci_homelab_load_balancer_backend_set.name
  ip_address       = oci_core_instance.master.public_ip
  load_balancer_id = oci_load_balancer_load_balancer.oci_homelab_load_balancer.id
  port             = "80"
}

resource "oci_load_balancer_backend" "oci_homelab_load_balancer_test_backend1" {
  #Required
  backendset_name  = oci_load_balancer_backend_set.oci_homelab_load_balancer_backend_set.name
  ip_address       = oci_core_instance.node.public_ip
  load_balancer_id = oci_load_balancer_load_balancer.oci_homelab_load_balancer.id
  port             = "80"
}

resource "oci_load_balancer_hostname" "oci_homelab_hostname1" {
  #Required
  hostname         = "app.free.com"
  load_balancer_id = oci_load_balancer_load_balancer.oci_homelab_load_balancer.id
  name             = "hostname1"
}

resource "oci_load_balancer_listener" "oci_homelab_load_balancer_listener0" {
  load_balancer_id         = oci_load_balancer_load_balancer.oci_homelab_load_balancer.id
  name                     = "http"
  default_backend_set_name = oci_load_balancer_backend_set.oci_homelab_load_balancer_backend_set.name
  hostname_names           = [oci_load_balancer_hostname.oci_homelab_hostname1.name]
  port                     = 80
  protocol                 = "HTTP"
  rule_set_names           = [oci_load_balancer_rule_set.oci_homelab_rule_set.name]

  connection_configuration {
    idle_timeout_in_seconds = "240"
  }
}

resource "oci_load_balancer_rule_set" "oci_homelab_rule_set" {
  items {
    action = "ADD_HTTP_REQUEST_HEADER"
    header = "example_header_name"
    value  = "example_header_value"
  }

  items {
    action          = "CONTROL_ACCESS_USING_HTTP_METHODS"
    allowed_methods = ["GET", "POST"]
    status_code     = "405"
  }

  load_balancer_id = oci_load_balancer_load_balancer.oci_homelab_load_balancer.id
  name             = "test_rule_set_name"
}

resource "oci_load_balancer_certificate" "oci_homelab_load_balancer_certificate" {
  load_balancer_id   = oci_load_balancer_load_balancer.oci_homelab_load_balancer.id
  ca_certificate     = tls_self_signed_cert.generated_tls.cert_pem
  certificate_name   = "certificate1"
  private_key        = tls_private_key.generated_tls.private_key_pem
  public_certificate = tls_self_signed_cert.generated_tls.cert_pem

  lifecycle {
    create_before_destroy = true
  }
}

resource "oci_load_balancer_listener" "oci_homelab_load_balancer_listener1" {
  load_balancer_id         = oci_load_balancer_load_balancer.oci_homelab_load_balancer.id
  name                     = "https"
  default_backend_set_name = oci_load_balancer_backend_set.oci_homelab_load_balancer_backend_set.name
  port                     = 443
  protocol                 = "HTTP"

  ssl_configuration {
    certificate_name        = oci_load_balancer_certificate.oci_homelab_load_balancer_certificate.certificate_name
    verify_peer_certificate = false
  }
}
