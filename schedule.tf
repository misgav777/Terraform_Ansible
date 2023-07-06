# EventBridge Rule to send an SNS notification
resource "aws_cloudwatch_event_rule" "ec2_state_rule" {
  name        = "ec2_state_rule"
  description = "Rule to send an SNS notification when the state of an EC2 instance changes"
  event_pattern = jsonencode({
    "source" : ["aws.ec2"],
    "detail-type" : ["EC2 Instance State-change Notification"],
    "detail" : {
      "state" : ["pending", "running", "shutting-down", "terminated", "stopping", "stopped"],
      "instance-id" : [data.aws_instance.foo.id]
    }
  })
}

resource "aws_cloudwatch_event_target" "ec2_state_target" {
  rule = aws_cloudwatch_event_rule.ec2_state_rule.name
  arn  = aws_sns_topic.ec2_state_change.arn
}

# Scheduler to start EC2
resource "aws_scheduler_schedule" "startInstances" {
  name       = "startInstances"
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }

  # Run it 7AM
  schedule_expression = "cron(0 7 * * ? *)"

  target {
    # This indicates that the event should be send to EC2 API and startInstances action should be triggered
    arn      = "arn:aws:scheduler:::aws-sdk:ec2:startInstances"
    role_arn = aws_iam_role.SchedulerEC2Start_Stop.arn

    # And this block will be passed to startInstances API
    input = jsonencode({
      InstanceIds = [
        data.aws_instance.foo.id
      ]
    })
  }
}


# # Scheduler to Stop EC2 

resource "aws_scheduler_schedule" "StopInstances" {
  name       = "StopInstances"
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }

  # Run it 19PM
  schedule_expression = "cron(0 19 * * ? *)"

  target {
    # This indicates that the event should be send to EC2 API and StopInstances action should be triggered
    arn      = "arn:aws:scheduler:::aws-sdk:ec2:stopInstances"
    role_arn = aws_iam_role.SchedulerEC2Start_Stop.arn

    # And this block will be passed to StopInstances API
    input = jsonencode({
      InstanceIds = [
        data.aws_instance.foo.id
      ]
    })
  }
}
