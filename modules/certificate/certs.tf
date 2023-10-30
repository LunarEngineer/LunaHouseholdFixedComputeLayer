# Certificate options:
# https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/locally_signed_cert

# resource "tls_locally_signed_cert" "example" {
#   cert_request_pem   = file("cert_request.pem")
#   ca_private_key_pem = file("ca_private_key.pem")
#   ca_cert_pem        = file("ca_cert.pem")

#   validity_period_hours = 12

#   allowed_uses = [
#     # "key_encipherment",
#     # "digital_signature",
#     # "server_auth",
#   ]
# }
# A Bootstrap certificate exposes
# * ca_key_algorithm (String) Name of the algorithm used when generating the private key provided in ca_private_key_pem.
# * cert_pem (String) Certificate data in PEM (RFC 1421) format. NOTE: the underlying libraries that generate this value append a \n at the end of the PEM. In case this disrupts your use case, we recommend using trimspace().
# * id (String) Unique identifier for this resource: the certificate serial number.
# * ready_for_renewal (Boolean) Is the certificate either expired (i.e. beyond the validity_period_hours) or ready for an early renewal (i.e. within the early_renewal_hours)?
# * validity_end_time (String) The time until which the certificate is invalid, expressed as an RFC3339 timestamp.
# * validity_start_time (String) The time after which the certificate is valid, expressed as an RFC3339 timestamp.