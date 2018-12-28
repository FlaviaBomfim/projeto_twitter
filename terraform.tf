## Provisionador, qual infra esta abaixo 

provider "aws" {
  region = "us-east-1"
}

# IAM - criando regra 

## IAM Role
resource "aws_iam_role" "iam_for_terraform_lambda" {
    name = "kinesis_streamer_iam_role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

## IAM Role Policies - Oque o frupo da regra criada, pode ter acesso

resource "aws_iam_role_policy_attachment" "terraform_lambda_iam_policy_basic_execution" {
  role = "${aws_iam_role.iam_for_terraform_lambda.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "terraform_lambda_iam_policy_kinesis_execution" {
  role = "${aws_iam_role.iam_for_terraform_lambda.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaKinesisExecutionRole"
}

# Lambda - Subindo e criando a funÃÃo do lambda 

resource "aws_lambda_function" "terraform_kinesis_streamer_func" {
    filename = "python.zip"
    function_name = "twitter-api"
    role = "${aws_iam_role.iam_for_terraform_lambda.arn}"
    handler = "lib/handler.demoHandler"
    runtime = "python3.7"
    source_code_hash = "${base64sha256(file("python.zip"))}"
}

resource "aws_lambda_event_source_mapping" "kinesis_lambda_event_mapping" {
    batch_size = 100
    event_source_arn = "${aws_kinesis_stream.kinesis_streamer_demo_stream.arn}"
    enabled = true
    function_name = "${aws_lambda_function.terraform_kinesis_streamer_func.arn}"
    starting_position = "TRIM_HORIZON"
}

# Kinesis - Criando 

## Kinesis Streams
resource "aws_kinesis_stream" "kinesis_streamer_demo_stream" {
    name = "twitter-api"
    shard_count = 1
    retention_period = 24
    shard_level_metrics = [
        "IncomingBytes",
        "OutgoingBytes"
    ]
}


## S3 - Criando 

resource "aws_s3_bucket" "logs" {
  bucket = "lambda-datafile"
  acl = "log-delivery-write"
}
