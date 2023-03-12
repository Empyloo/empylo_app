#!/bin/bash

# Create the UI directory
mkdir lib/ui

# Create the atoms, molecules, organisms, and templates directories
mkdir lib/ui/molecules
mkdir lib/ui/pages

# Create the necessary subdirectories for each directory
mkdir lib/ui/molecules/buttons
mkdir lib/ui/molecules/inputs
mkdir lib/ui/molecules/text
mkdir lib/ui/molecules/icons
mkdir lib/ui/molecules/images


# Create the necessary files for each directory
touch lib/ui/molecules/buttons/elevated_buttons.dart
touch lib/ui/molecules/buttons/icon_buttons.dart
touch lib/ui/molecules/buttons/outline_buttons.dart
touch lib/ui/molecules/buttons/text_buttons.dart
touch lib/ui/molecules/buttons/floating_action_buttons.dart
touch lib/ui/molecules/buttons/popup_menu_buttons.dart

touch lib/ui/molecules/inputs/checkboxs.dart
touch lib/ui/molecules/inputs/radios.dart
touch lib/ui/molecules/inputs/selects.dart
touch lib/ui/molecules/inputs/switchs.dart
touch lib/ui/molecules/inputs/text_fields.dart
touch lib/ui/molecules/inputs/text_form_fields.dart
touch lib/ui/molecules/inputs/sliders.dart
touch lib/ui/molecules/inputs/date_time_pickers.dart
touch lib/ui/molecules/inputs/file_uploaders.dart

touch lib/ui/molecules/text/text_field.dart

touch lib/ui/molecules/icons/icons.dart

touch lib/ui/molecules/images/images.dart

gcloud compute ssl-certificates create empylo-ssl-certificate \
    --description='Empylo ssl certificate for `empylo.com` and `app.empylo.com`.' \
    --domains='empylo.com,app.empylo.com' \
    --global

gcloud compute backend-buckets create landing-page-backend-bucket \
    --gcs-bucket-name=empylo-landing-page \
    --cache-mode=CACHE_ALL_STATIC \
    --load-balancing-scheme=EXTERNAL

gcloud compute url-maps create empylo-url-map \
    --default-backend-bucket=landing-page-backend-bucket

gcloud compute target-https-proxies create empylo-https-proxy \
    --ssl-certificates=empylo-ssl-certificate \
    --url-map=empylo-url-map

gcloud compute forwarding-rules create empylo-forwarding-rule \
       --load-balancing-scheme=EXTERNAL \
       --network-tier=PREMIUM \
       --address=34.160.108.159 \
       --target-https-proxy=empylo-https-proxy \
       --global \
       --ports=443

gcloud compute ssl-certificates describe empylo-ssl-certificate \
    --global \
    --format="get(managed.domainStatus)"

dig www.empylo.com
echo | openssl s_client -showcerts -servername empylo.com -connect 34.160.108.159:443 -verify 99 -verify_return_error

gcloud compute url-maps add-path-matcher empylo-url-map \
    --path-matcher-name app-path-matcher \
    --new-hosts app.empylo.com \
    --default-backend-bucket app-backend-bucket

gcloud compute url-maps add-path-matcher empylo-url-map \
--default-backend-bucket app-backend-bucket \
--path-matcher-name bes-path-matcher \
--path-rules="/api/*=empylo-bes"