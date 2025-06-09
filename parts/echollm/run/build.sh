#!/bin/bash
set -euo pipefail
source /home/alabi-ayobami/echo_llm/parts/echollm/run/environment.sh
set -x
git clone --depth 1 -b stable https://github.com/flutter/flutter.git /home/alabi-ayobami/echo_llm/parts/echollm/build/flutter-distro
rm /home/alabi-ayobami/echo_llm/parts/echollm/build/flutter-distro/engine/src/.gn
flutter precache --linux
flutter pub get
flutter build linux --release --verbose --target lib/main.dart
cp -r build/linux/*/release/bundle/* $CRAFT_PART_INSTALL/
