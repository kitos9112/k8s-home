# Configure the PagerDuty provider
terraform {
  required_providers {
    pagerduty = {
      source  = "pagerduty/pagerduty"
      version = "1.7.11"
    }
  }
}

provider "pagerduty" {
  token = var.pagerduty_token
}
