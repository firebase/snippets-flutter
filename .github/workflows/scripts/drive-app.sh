#!/bin/bash

PROJECT_NAME=$1
TARGET_PATH="packages/$PROJECT_NAME/"

# The && are necessary for some reason when using the Android Emulator action
pushd "$TARGET_PATH" || exit &&
flutter clean &&
flutter pub get &&
dart format . &&
flutter test integration_test
