resource "tls_private_key" "generated_tls" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "tls_self_signed_cert" "generated_tls" {
  private_key_pem = tls_private_key.generated_tls.private_key_pem

  subject {
    organization = "Oracle"
    country      = "US"
    locality     = "Austin"
    province     = "TX"
  }

  validity_period_hours = 8760 # 1 year

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
    "cert_signing"
  ]

  is_ca_certificate = true
}
