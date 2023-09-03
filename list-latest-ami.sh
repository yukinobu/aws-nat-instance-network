#!/bin/bash
set -euo pipefail

cat <<'EOS'
Mappings:
  RegionToAlpineLinuxAMI:
EOS

aws account list-regions | jq -cr '.Regions[].RegionName'| while read -r region; do
	awsout=$(aws ec2 describe-images \
		--owners 538276064493 \
		--region "${region}" \
		--filters \
			Name=name,Values='alpine-3.*-aarch64-uefi-cloudinit-*' \
			Name=state,Values=available \
		--output text \
		--query 'reverse(sort_by(Images, &CreationDate))[].[ImageId,Name,CreationDate]' 2>/dev/null | \
		sort -r -k2 | head -1) || continue
	amiid=$(echo "${awsout}" | cut -d $'\t' -f 1)
	aminame=$(echo "${awsout}" | cut -d $'\t' -f 2)
	amidate=$(echo "${awsout}" | cut -d $'\t' -f 3)
	cat <<-EOS
		${region}:
		  ID: ${amiid}
		  Name: "${aminame}"
		  Date: "${amidate}"
	EOS
done
