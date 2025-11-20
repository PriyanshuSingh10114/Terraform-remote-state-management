resource "aws_s3_bucket" "example" {
  bucket = "raj-state-testing-bucket"

  tags = {
    Name        = "raj-state-testing-bucket"
  }
}
