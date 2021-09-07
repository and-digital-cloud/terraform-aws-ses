// This is the SNS Topic that any ALARM will trigger.
resource "aws_sns_topic" "alert_sns_topic" {
  name = "email-alert-topic"
  tags = var.tags
}

# Subscription associated with SNS topic
resource "aws_sns_topic_subscription" "alert_sns_topic" {
  topic_arn = aws_sns_topic.alert_sns_topic.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

// This is the SNS Topic that 8.5 bounce and 0.4 complaint ALARM will trigger.
resource "aws_sns_topic" "suspend_alert_sns_topic" {
  name = "suspend-email-alert-topic"
  tags = var.tags
}

resource "aws_sns_topic_subscription" "sns_suspend_lambda" {
  topic_arn = aws_sns_topic.suspend_alert_sns_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.function.arn
}

# Subscription associated with SNS suspend email
resource "aws_sns_topic_subscription" "sns_suspend_email" {
  topic_arn = aws_sns_topic.suspend_alert_sns_topic.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

// Alarm to Notify when Bounce Rate hits 5%
resource "aws_cloudwatch_metric_alarm" "bounce_alarm_5" {
  alarm_name          = "email-bounceback-5-percent"
  alarm_description   = "notification for when the bounceback rate hits 5%"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "Reputation.BounceRate"
  namespace           = "AWS/SES"
  statistic           = "Average"
  period              = 3600
  threshold           = "5"
  treat_missing_data  = "ignore"

  alarm_actions = ["${aws_sns_topic.alert_sns_topic.arn}"]

  tags = var.tags
}

// Alarm to Notify when Bounce Rate hits 7%
resource "aws_cloudwatch_metric_alarm" "bounce_alarm_7" {
  alarm_name          = "email-bounceback-7-percent"
  alarm_description   = "notification for when the bounceback rate hits 7%"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "Reputation.BounceRate"
  namespace           = "AWS/SES"
  statistic           = "Average"
  period              = 3600
  threshold           = "7"
  treat_missing_data  = "ignore"

  alarm_actions = ["${aws_sns_topic.alert_sns_topic.arn}"]

  tags = var.tags
}

// Alarm to Notify when Bounce Rate hits 8.5%
resource "aws_cloudwatch_metric_alarm" "bounce_alarm_85" {
  alarm_name          = "email-bounceback-8.5-percent"
  alarm_description   = "notification for when the bounceback rate hits 8.5%"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "Reputation.BounceRate"
  namespace           = "AWS/SES"
  statistic           = "Average"
  period              = 3600
  threshold           = "8.5"
  treat_missing_data  = "ignore"

  alarm_actions = ["${aws_sns_topic.suspend_alert_sns_topic.arn}"]

  tags = var.tags
}

// Alarm to Notify when Complaint Rate hits 0.1%
resource "aws_cloudwatch_metric_alarm" "complaint_alarm_02" {
  alarm_name          = "email-complaint-0.2-percent"
  alarm_description   = "notification for when the complaint rate hits 0.2%"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "Reputation.ComplaintRate"
  namespace           = "AWS/SES"
  statistic           = "Average"
  period              = 3600
  threshold           = "0.002"
  treat_missing_data  = "ignore"

  alarm_actions = ["${aws_sns_topic.alert_sns_topic.arn}"]

  tags = var.tags
}

// Alarm to Notify when Complaint Rate hits 0.3%
resource "aws_cloudwatch_metric_alarm" "complaint_alarm_03" {
  alarm_name          = "email-complaint-0.3-percent"
  alarm_description   = "notification for when the complaint rate hits 0.3%"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "Reputation.ComplaintRate"
  namespace           = "AWS/SES"
  statistic           = "Average"
  period              = 3600
  threshold           = "0.003"
  treat_missing_data  = "ignore"

  alarm_actions = ["${aws_sns_topic.alert_sns_topic.arn}"]

  tags = var.tags
}

// Alarm to Notify when Complaint Rate hits 0.4%
resource "aws_cloudwatch_metric_alarm" "complaint_alarm_04" {
  alarm_name          = "email-complaint-0.4-percent"
  alarm_description   = "notification for when the complaint rate hits 0.4%"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "Reputation.ComplaintRate"
  namespace           = "AWS/SES"
  statistic           = "Average"
  period              = 3600
  threshold           = "0.004"
  treat_missing_data  = "ignore"

  alarm_actions = ["${aws_sns_topic.suspend_alert_sns_topic.arn}"]

  tags = var.tags
}
