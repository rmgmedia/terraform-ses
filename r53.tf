data "aws_route53_zone" "selected" {
  name         = var.domain
  private_zone = false
}

resource "aws_route53_record" "domain_amazonses_verification_record" {
  count   = data.aws_route53_zone.selected.zone_id != null ? 1 : 0
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "_amazonses.${var.domain}"
  type    = "TXT"
  ttl     = "3600"
  records = concat([aws_ses_domain_identity.domain.verification_token], var.ses_records)
}

resource "aws_route53_record" "domain_amazonses_dkim_record" {
  count   = data.aws_route53_zone.selected.zone_id != null ? 3 : 0
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${element(aws_ses_domain_dkim.dkim.dkim_tokens, count.index)}._domainkey.${var.domain}"
  type    = "CNAME"
  ttl     = "3600"
  records = ["${element(aws_ses_domain_dkim.dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
}
