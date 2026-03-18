provider "aws" {
    region = "us-east-1"
}

variable "bucket_name" {
    type = string
}

resource "aws_s3_bucket" "static_site_bucket" {
    bucket = "static-site-${var.bucket_name}"
    website {
        index_document = "index.html"
        error_document = "error.html"
    }

    tags = {
        Name = "static-site-${var.bucket_name}"
        Environment = "Production"
    }
}

resource "aws_s3_bucket_public_access_block" "static_site_bucket" {
    bucket = aws_s3_bucket.static_site_bucket.id
    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "static_site_bucket_policy" {
    bucket = aws_s3_bucket.static_site_bucket.id
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "s3:GetObject"
                Effect = "Allow"
                Principal = "*"
                Resource = "arn:aws:s3:::static-site-${var.bucket_name}/*"
            }
        ]
    })
}
    