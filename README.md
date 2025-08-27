# 🌗 Flutter Theme & Localization Toggle (GetX)

This project demonstrates how to integrate a **Theme Toggle** and **Language Change** functionality in a Flutter application using the **GetX** package.

---

## 📑 Table of Contents

* [✨ Features](#-features)
* [🧩 Code Snippet](#-code-snippet)
* [🔄 Project Rename Notes](#-project-rename-notes)

    * [1️⃣ Update pubspec.yaml](#1️⃣-update-pubspecyaml)
    * [2️⃣ Update Imports in lib/](#2️⃣-update-imports-in-lib)
    * [3️⃣ Run PowerShell Script (Windows)](#3️⃣-run-powershell-script-windows)
    * [✅ Result](#-result)
* [💡 Tips](#-tips)

---

## ✨ Features

* Toggle between **Light Mode** and **Dark Mode**
* Open a **language selection bottom sheet** to switch app language
* Uses `Obx` for reactive UI updates with GetX

---

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
```

---

# 🔄 Project Rename Notes

This section explains how to rename your Flutter project from **`file_stracture` → `hash_code`**.

### 1️⃣ Update `pubspec.yaml`

Open `pubspec.yaml` and change:

```yaml
name: file_stracture
```

to:

```yaml
name: hash_code
```

---

### 2️⃣ Update Imports in `lib/`

Replace all occurrences of:

```dart
import 'package:file_stracture/...
```

with:

```dart
import 'package:hash_code/...
```

---

### 3️⃣ Run PowerShell Script (Windows)

To automate the rename in all Dart files, run:

```powershell
# Update pubspec.yaml project name
(Get-Content pubspec.yaml) -replace 'name: file_stracture','name: hash_code' | Set-Content pubspec.yaml

# Update all Dart imports inside lib/
Get-ChildItem -Recurse -Include *.dart -Path lib | ForEach-Object {
    (Get-Content $_) -replace 'package:file_stracture','package:hash_code' | Set-Content $_
}
```

---

### ✅ Result

* Project name updated in **pubspec.yaml**
* All imports updated from `package:file_stracture/...` → `package:hash_code/...`

**Before:**

```dart
import 'package:file_stracture/routes/route_helper.dart';
```

**After:**

```dart
import 'package:hash_code/routes/route_helper.dart';
```

---

## 💡 Tips

* Run the following after renaming:

```bash
flutter clean
flutter pub get
```

* Make sure **Android/iOS package names** are also consistent if you plan to publish the app
* Commit these changes to Git for tracking

---

## 📸 Optional: Screenshots / Demo GIF

You can add screenshots or GIFs of your app here to make your README visually appealing.
