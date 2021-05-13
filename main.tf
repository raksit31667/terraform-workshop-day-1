resource "aws_dynamodb_table" "dynamodb" {
  hash_key = "RideId"
  name = "EarthRides"
  write_capacity = 20
  read_capacity = 20
  attribute {
    name = "RideId"
    type = "S"
  }

  tags = {
    Name = "Earth"
  }
}

resource "aws_iam_role" "iam-for-lambda" {
  name = "earth-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "iam-policy-for-lambda" {
  name = "lambda-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid : "SpecificTable",
        Effect : "Allow",
        Action : [
          "dynamodb:*"
        ],
        Resource : aws_dynamodb_table.dynamodb.arn
      }
    ]
  })

  role = aws_iam_role.iam-for-lambda.id
}

resource "aws_lambda_function" "wild-rydes-lambda" {
  filename         = "requestUnicorn.zip"
  function_name    = "EarthRequestUnicorn"
  handler          = "requestUnicorn.handler"
  role             = aws_iam_role.iam-for-lambda.arn
  runtime          = "nodejs12.x"
  source_code_hash = filebase64sha256("requestUnicorn.zip")
}