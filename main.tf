provider "aws" {
  region = "us-west-2"
}

resource "random_id" "random" {
  byte_length = 4
}

resource "aws_kms_key" "bucket_key" {
  description             = "KMS key for S3 bucket encryption"
  deletion_window_in_days = 7
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "bootcamp32-${var.env}-${random_id.random.hex}"

  acl = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.bucket_key.arn
      }
    }
  }
}

variable "env" {
  description = "Environment"
  type        = string
  default     = "dev"
}
