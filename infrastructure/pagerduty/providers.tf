# Configure the PagerDuty provider
terraform {
  required_providers {
    pagerduty = {
      source  = "pagerduty/pagerduty"
      version = "3.0.3"
    }
  }
}

provider "pagerduty" {
  token = var.pagerduty_token
}
