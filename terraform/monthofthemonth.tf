# Variables
variable "access_key" {
  description = "AWS access key"
}
variable "secret_key" {
  description = "AWS secret key"
}
variable "region" {
  description = "AWS region"
}
variable "dnsimple_account" {
  description = "DNSimple account ID"
}
variable "dnsimple_token" {
  description = "DNSimple API v1 token"
}
variable "domain" {
  description = "domain name"
}

# Providers
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

provider "dnsimple" {
  token = "${var.dnsimple_token}"
  account = "${var.dnsimple_account}"
}

resource "aws_s3_bucket" "website" {
  bucket = "${var.domain}"
  acl = "public-read"
  force_destroy = true

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[{
    "Sid":"PublicReadForGetBucketObjects",
        "Effect":"Allow",
      "Principal": "*",
      "Action":"s3:GetObject",
      "Resource":["arn:aws:s3:::${var.domain}/*"
      ]
    }
  ]
}
POLICY

  website {
    index_document = "index.html"
  }
}

resource "dnsimple_record" "alias" {
  domain = "${var.domain}"
  name = ""
  value = "${aws_s3_bucket.website.website_endpoint}"
  type = "ALIAS"
  ttl = 60
}

resource "aws_s3_bucket_object" "index" {
  bucket = "${aws_s3_bucket.website.id}"
  key = "index.html"
  source = "index.html"
  etag = "${md5(file("index.html"))}"
  content_type = "text/html"
  acl = "public-read"
}

resource "aws_s3_bucket_object" "basscss" {
  bucket = "${aws_s3_bucket.website.id}"
  key = "basscss.min.css"
  source = "basscss.min.css"
  etag = "${md5(file("basscss.min.css"))}"
  content_type = "text/css"
  acl = "public-read"
}

resource "aws_s3_bucket_object" "header" {
  bucket = "${aws_s3_bucket.website.id}"
  key = "header.jpeg"
  source = "header.jpeg"
  etag = "${md5(file("header.jpeg"))}"
  content_type = "image/jpeg"
  acl = "public-read"
}
