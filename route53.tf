data "aws_route53_zone" "vpc" {
  name = var.dns_zone
}

resource "aws_route53_record" "jenkins_cname" {
  zone_id = data.aws_route53_zone.vpc.zone_id
  name    = "jenkins.${var.dns_zone}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.ingress_nginx.status.0.load_balancer.0.ingress.0.hostname]

  depends_on = [
    helm_release.ingress-controller,
    helm_release.jenkins,
  ]
}

resource "aws_route53_record" "k8s_dashboard_cname" {
  zone_id = data.aws_route53_zone.vpc.zone_id
  name    = "dashboard.${var.dns_zone}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.k8s_dashboard_ingress.status.0.load_balancer.0.ingress.0.hostname]

  depends_on = [
    helm_release.ingress-controller,
    helm_release.k8s_dashboard,
  ]
}

resource "aws_route53_record" "keycloak_cname" {
  zone_id = data.aws_route53_zone.vpc.zone_id
  name    = "keycloak.${var.dns_zone}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.keycloak_ingress.status.0.load_balancer.0.ingress.0.hostname]

  depends_on = [
    helm_release.ingress-controller,
    helm_release.keycloak,
  ]
}
