# Dependency Audit (Flutter 3.27 / Dart 3.6.2, Android 16KB page support)

This document lists libraries that are outdated, discontinued, or incompatible. Each entry includes the pubspec location (line number) and in-code references.

- download (deprecated / not used on mobile)
  - pubspec.yaml: line 43 (commented out)
  - code references:
    - lib/custom_code/actions/download_f_f_uploaded_file.dart:15 (import) — commented out

- share (discontinued; use share_plus)
  - pubspec.yaml: line 86 (commented out)
  - iOS Podfile.lock: still lists `share (0.0.1)`; will be pruned on next iOS pod install
  - code references: none (we use share_plus)

- internet_file (incompatible with http ^1.x)
  - pubspec.yaml: line 63 (commented out)
  - code references:
    - lib/flutter_flow/flutter_flow_pdf_viewer.dart:2 import — commented out
    - same file: replaced InternetFile.get(networkPath) with http.get(...).bodyBytes at line ~46

- flutter_plugin_android_lifecycle (pin for Dart 3.6.x)
  - pubspec.yaml: line 48 pinned to 2.0.29 (2.0.30+ requires Dart >=3.7)

- device_info_plus_platform_interface (SDK constraint)
  - pubspec.yaml: line 42 pinned to 7.0.2 to keep Dart 3.6.2 compatibility

- webview_flutter_android (unpinned; allow 4.x)
  - pubspec.yaml: line 119 commented the old 3.16.7 pin
  - Code references: none direct; used transitively via webview_flutter if present

- pdf (any) — review later
  - pubspec.yaml: line 74 (`any`) — keep for now; code relies on pdf widgets in
    lib/custom_code/actions/pdf_*.dart files

- image (any) — review later
  - pubspec.yaml: line 54 (`any`) — used in PDF generation actions

- typed_data (any) — review later
  - pubspec.yaml: line 101 (`any`) — used generically

Notes
- Android 16KB page support enabled: android/gradle.properties has android.experimental.enable16kPageSupport=true
- AGP/Kotlin aligned: android/settings.gradle uses AGP 8.6.0 / Kotlin 1.9.24. Root android/build.gradle updated to match and compileSdk bumped to 35
- Gradle wrapper 8.7 confirmed

Next steps
- Run flutter clean; flutter pub get; flutter build apk to validate
- If upgrading to Dart 3.7+ later, unpin flutter_plugin_android_lifecycle and device_info_plus_platform_interface
- Consider pinning pdf/image to specific known-good versions if further breakages appear

