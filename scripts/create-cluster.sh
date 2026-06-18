#!/bin/bash
set -euo pipefail

TERRAFORM_DIR="$(dirname "${BASH_SOURCE[0]}")/../terraform"
OUTPUT_FILE="${TERRAFORM_DIR}/terraform-output.tfout"

required_tools=(terraform aws ansible)
missing_tools=()
for tool in "${required_tools[@]}"; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    missing_tools+=("$tool")
  fi
done

if [[ ${#missing_tools[@]} -gt 0 ]]; then
  echo "[ERROR] Missing required CLI tools: ${missing_tools[*]}"
  echo "Install the missing tools and try again."
  exit 1
fi

echo "[INFO] Validating AWS credentials..."
if [[ -n "${AWS_ACCESS_KEY_ID:-}" && -n "${AWS_SECRET_ACCESS_KEY:-}" ]]; then
  echo "[INFO] Using AWS credentials from environment variables."
elif command -v aws >/dev/null 2>&1; then
  if [[ -n "${AWS_PROFILE:-}" ]]; then
    echo "[INFO] Using AWS CLI profile '${AWS_PROFILE}'."
  else
    available_profiles="$(aws configure list-profiles 2>/dev/null || true)"
    if [[ -n "$available_profiles" ]]; then
      export AWS_PROFILE="$(printf '%s' "$available_profiles" | head -n1)"
      echo "[INFO] AWS_PROFILE not set; using first available AWS CLI profile '${AWS_PROFILE}'."
    else
      echo "[ERROR] No AWS CLI profile found. Configure a profile with 'aws configure' or set AWS_PROFILE."
      exit 1
    fi
  fi
else
  echo "[ERROR] No AWS credentials found in environment. Please set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY, or configure an AWS CLI profile."
  exit 1
fi

if [[ -z "${AWS_DEFAULT_REGION:-}" && -n "${AWS_PROFILE:-}" ]]; then
  AWS_DEFAULT_REGION="$(aws configure get region --profile "$AWS_PROFILE" 2>/dev/null || true)"
  if [[ -n "$AWS_DEFAULT_REGION" ]]; then
    export AWS_DEFAULT_REGION
  fi
fi

echo "[INFO] AWS region is set to: ${AWS_DEFAULT_REGION:-unknown}${AWS_PROFILE:+ (via profile ${AWS_PROFILE})}"

cd "$TERRAFORM_DIR"

echo "[INFO] Initializing Terraform..."
terraform init -input=false

echo "[INFO] Applying Terraform configuration..."
terraform apply -auto-approve

echo "[INFO] Capturing Terraform outputs to ${OUTPUT_FILE}..."
terraform output -json > "$OUTPUT_FILE"

if [[ -s "$OUTPUT_FILE" ]]; then
  echo "[INFO] Terraform outputs saved successfully."
  echo "[INFO] Output file: $OUTPUT_FILE"
else
  echo "[WARN] Terraform output file was created but is empty. Verify your Terraform outputs."
fi

exit 0
