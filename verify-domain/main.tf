resource "aws_ses_domain_identity" "ses_domain" {
  domain = "${var.domain}"
}

resource "aws_route53_record" "amazonses_verification_record" {
  zone_id = "${data.aws_route53_zone.hosted_zone.zone_id}"
  name    = "_amazonses.${aws_ses_domain_identity.ses_domain.id}"
  type    = "TXT"
  ttl     = "600"
  records = ["${aws_ses_domain_identity.ses_domain.verification_token}"]
}

resource "aws_ses_domain_identity_verification" "verification" {
  domain = "${aws_ses_domain_identity.ses_domain.id}"
  depends_on = ["aws_route53_record.amazonses_verification_record"]
}