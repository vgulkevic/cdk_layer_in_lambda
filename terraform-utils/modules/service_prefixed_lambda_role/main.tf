
resource "aws_iam_role" "execution_role" {
  name               = "${var.name_prefix}-LambdaExecRole"
  assume_role_policy = templatefile("${path.module}/lambda-assume-role-policy.tpl", {})
}

#################### IAM POLICY ##################
resource "aws_iam_policy" "prefix_base_policy" {
  for_each = toset(var.allowed_service_prefixes)

  name_prefix = var.name_prefix
  policy      = data.aws_iam_policy_document.prefixed_policy_document[each.key].json
}

resource "aws_iam_policy" "cloudwatch_policy" {
  name_prefix = var.name_prefix
  policy      = data.aws_iam_policy_document.cloudwatch_logs_policy_document.json
}

resource "aws_iam_policy" "ses_policy" {
  name_prefix = var.name_prefix
  policy      = data.aws_iam_policy_document.ses_policy_document.json
}

#################### IAM POLICY ATTACHMENT ##################
resource "aws_iam_role_policy_attachment" "policy_attachment" {
  for_each = toset(var.allowed_service_prefixes)

  policy_arn = aws_iam_policy.prefix_base_policy[each.key].arn
  role       = aws_iam_role.execution_role.name
}

resource "aws_iam_role_policy_attachment" "cloudwatch_policy_attachment" {
  policy_arn = aws_iam_policy.cloudwatch_policy.arn
  role       = aws_iam_role.execution_role.name
}

resource "aws_iam_role_policy_attachment" "ses_policy_attachment" {
  policy_arn = aws_iam_policy.ses_policy.arn
  role       = aws_iam_role.execution_role.name
}

resource "aws_iam_role_policy_attachment" "additional_policy_attachment" {
  count = length(var.additional_policies)

  policy_arn = var.additional_policies[count.index]
  role       = aws_iam_role.execution_role.name
}

#################### IAM POLICY DOCUMENT ##################
data "aws_iam_policy_document" "prefixed_policy_document" {
  for_each = toset(var.allowed_service_prefixes)
  version  = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "s3:*",
      "dynamodb:*",
      "states:*",
      "sns:*",
      "sqs:*"
    ]
    resources = [
      "arn:aws:s3:::${each.value}*",
      "arn:aws:dynamodb:*:*:table/${each.value}*",
      "arn:aws:states:*:*:${each.value}*",
      "arn:aws:sns:*:*:${each.value}*",
      "arn:aws:sqs:*:*:${each.value}*"
    ]
  }
}

data "aws_iam_policy_document" "cloudwatch_logs_policy_document" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "ses_policy_document" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail"
    ]
    resources = [
      "*"
    ]
  }
}
