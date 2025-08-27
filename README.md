# Flutter Theme & Localization Toggle (GetX)

This snippet demonstrates how to integrate a **Theme Toggle** and **Language Change** functionality in a Flutter application using the **GetX** package.

## ✨ Features
- Toggle between **Light Mode** and **Dark Mode**
- Open a **language selection bottom sheet** to switch app language
- Uses `Obx` for reactive UI updates with GetX

## 🧩 Code Snippet

```dart
// Theme change
final themeController = Get.find<ThemeController>();
ElevatedButton(
  onPressed: () {
    themeController.toggleTheme();
  },
  child: Obx(() => Text(
      themeController.isDarkMode ? "Switch to Light Mode" : "Switch to Dark Mode"
  )),
),
// Language change
final localizationController = Get.find<LocalizationController>();
ElevatedButton(
  onPressed: () {
    localizationController.showLanguageBottomSheet(context);
  },
  child: Text('change_language'.tr, style: TextStyle(color: Colors.white)),
),


🔄 Project Rename Notes

To rename your Flutter project from file_stracture → hash_code, follow these steps:

1️⃣ Update pubspec.yaml

Change the project name line:

name: file_stracture


to:

name: hash_code

2️⃣ Update Imports in lib/

Replace all occurrences of:

import 'package:file_stracture/...


with:

import 'package:hash_code/...

3️⃣ Run PowerShell Script (Windows)
# Update pubspec.yaml project name
(Get-Content pubspec.yaml) -replace 'name: file_stracture','name: hash_code' | Set-Content pubspec.yaml

# Update all Dart imports inside lib/
Get-ChildItem -Recurse -Include *.dart -Path lib | ForEach-Object {
    (Get-Content $_) -replace 'package:file_stracture','package:hash_code' | Set-Content $_
}