#!/bin/bash
set -euo pipefail

TERRAFORM_DIR="$(dirname "${BASH_SOURCE[0]}")/../terraform"
OUTPUT_FILE="${TERRAFORM_DIR}/terraform-output.tfout"

required_tools=(terraform aws jq)
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

# Parse arguments
confirm=true
while [[ $# -gt 0 ]]; do
  case "$1" in
    -y|--yes|--force)
      confirm=false
      shift
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

if [[ "$confirm" == "true" ]]; then
  read -p "Are you sure you want to destroy the infrastructure and delete the cluster? [y/N]: " response
  if [[ ! "$response" =~ ^[yY](es)?$ ]]; then
    echo "[INFO] Delete aborted by user."
    exit 0
  fi
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

# Retrieve bastion IP if available for cleanup
BASTION_IP=""
if [[ -s "$OUTPUT_FILE" ]]; then
  BASTION_IP="$(jq -r '.bastion_public_ip.value // empty' "$OUTPUT_FILE")"
fi

# Clean up hosts entry and SSH known_hosts
if [[ -n "$BASTION_IP" ]]; then
  echo "[INFO] Cleaning up /etc/hosts entry for bastion IP ${BASTION_IP}..."
  if grep -qE "^[[:space:]]*${BASTION_IP}[[:space:]]+bastion-01" /etc/hosts 2>/dev/null; then
    echo "[INFO] Removing bastion-01 entry from /etc/hosts (requires sudo)..."
    sudo sed -i "/^[[:space:]]*${BASTION_IP}[[:space:]]\+bastion-01/d" /etc/hosts
  else
    echo "[INFO] Bastion-01 entry not found in /etc/hosts or not matching ${BASTION_IP}."
  fi

  KNOWN_HOSTS="$HOME/.ssh/known_hosts"
  if [[ -f "$KNOWN_HOSTS" ]]; then
    echo "[INFO] Removing bastion public IP from SSH known_hosts..."
    ssh-keygen -f "$KNOWN_HOSTS" -R "$BASTION_IP" >/dev/null 2>&1 || true
  fi
else
  echo "[INFO] No bastion public IP found in output file. Skipping /etc/hosts and known_hosts cleanup."
fi

# Run Terraform Destroy
cd "$TERRAFORM_DIR"
echo "[INFO] Initializing Terraform..."
terraform init -input=false

echo "[INFO] Destroying Terraform provisioned infrastructure..."
terraform destroy -auto-approve

# Clean up local output files
if [[ -f "$OUTPUT_FILE" ]]; then
  echo "[INFO] Removing Terraform outputs file..."
  rm -f "$OUTPUT_FILE"
fi

echo "[INFO] Cleanup and deletion completed successfully."
exit 0
