
variable "account_num" { }

resource "aws_sns_topic" "topic1" {
  name = "topic1"
}

resource "aws_sns_topic" "topic2" {
  name = "topic2"
}

resource "aws_sns_topic_subscription" "topic1_sub" {
    topic_arn = "${aws_sns_topic.topic1.arn}"
    protocol = "lambda"
    endpoint = "arn:aws:lambda:us-west-2:${var.account_num}:function:topic1_func"
}

resource "aws_sns_topic_subscription" "topic2_sub" {
    topic_arn = "${aws_sns_topic.topic2.arn}"
    protocol = "lambda"
    endpoint = "arn:aws:lambda:us-west-2:${var.account_num}:function:topic2_func"
}

