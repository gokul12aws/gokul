resource "aws_s3_bucket" "terraform_state"{

  bucket   = "gokkul-12345"
  acl      = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "terraformstateBucket"
    Environment = "Infrastructure"
  }
}

resource "aws_dynamodb_table" "terraform_lock"
  name         = "dynamo-table"

  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Artist"

  attribute {
    name = "Artist"
    type = "S"
  }
}
