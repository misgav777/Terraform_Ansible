# Create an IAM policy
resource "aws_iam_policy" "start_stop_policy" {
  name = "start_stop_policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "ec2Stop",
        "Effect" : "Allow",
        "Action" : [
          "ec2:StartInstances",
          "ec2:StopInstances"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# Create an IAM role
resource "aws_iam_role" "SchedulerEC2Start_Stop" {
  name = "SchedulerEC2Start_Stop"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "scheduler.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

# Attach the IAM policy to the IAM role
resource "aws_iam_role_policy_attachment" "start_stop_policy" {
  role       = aws_iam_role.SchedulerEC2Start_Stop.name
  policy_arn = aws_iam_policy.start_stop_policy.arn
}
