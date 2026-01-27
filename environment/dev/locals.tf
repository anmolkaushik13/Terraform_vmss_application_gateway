locals {
  environment="dev"
  project="elearn"
  location_code="ci"
  location="Central India"
  name_pattern="${local.project}-${local.environment}-${local.location_code}"
}