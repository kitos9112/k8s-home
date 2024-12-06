# Configure the PagerDuty provider
terraform {
  required_providers {
    pagerduty = {
      source  = "pagerduty/pagerduty"
      version = "3.18.1"
    }
  }
}

provider "pagerduty" {
  token = var.pagerduty_token
}
