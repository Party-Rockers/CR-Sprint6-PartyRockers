resource "aws_sns_topic" "sns" {
  name = "${var.default_tags.Name}-sns"
}

resource "aws_sns_topic_subscription" "email-target1" {
  topic_arn = aws_sns_topic.sns.arn
  protocol  = "email"
  endpoint  = "sarah.moreland@slalom.com"
}

resource "aws_sns_topic_subscription" "email-target2" {
  topic_arn = aws_sns_topic.sns.arn
  protocol  = "email"
  endpoint  = "kyle.lierer@slalom.com"
}

resource "aws_sns_topic_subscription" "email-target3" {
  topic_arn = aws_sns_topic.sns.arn
  protocol  = "email"
  endpoint  = "maya.rao@slalom.com"
}