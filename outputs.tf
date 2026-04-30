output "bucket_name" {
  description = "Nombre del bucket S3"
  value       = aws_s3_bucket.main.bucket
}

output "bucket_arn" {
  description = "ARN del bucket S3"
  value       = aws_s3_bucket.main.arn
}