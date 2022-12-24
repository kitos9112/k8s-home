# Configure the PagerDuty provider
terraform {
  required_providers {
    pagerduty = {
      source  = "pagerduty/pagerduty"
      version = "2.8.1"
    }
  }
}

provider "pagerduty" {
  token = var.pagerduty_token
}
