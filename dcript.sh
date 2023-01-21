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
