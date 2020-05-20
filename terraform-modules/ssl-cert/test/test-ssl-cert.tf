
/* 
* Test ssl_certificate module
*/

module "test-ssl-cert" {
  source = "../"

  ssl_certificate_name = "fake-host.fake-domain.net"
  ssl_certificate_key  = file("fake-host.fake-domain.net.key")
  ssl_certificate_cert = file("fake-host.fake-domain.net.cert")
}
