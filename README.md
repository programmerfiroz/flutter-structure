# Flutter Theme & Localization Toggle (GetX)

This snippet demonstrates how to integrate a **Theme Toggle** and **Language Change** functionality in a Flutter application using the **GetX** package.

## Features

- Toggle between **Light Mode** and **Dark Mode**
- Open a **language selection bottom sheet** to switch app language
- Uses `Obx` for reactive UI updates with GetX
  
## Code Snippet

```Theme change
final themeController = Get.find<ThemeController>();
ElevatedButton(
  onPressed: () {
    themeController.toggleTheme();
  },
  child: Obx(() => Text(
      themeController.isDarkMode ? "Switch to Light Mode" : "Switch to Dark Mode"
  )),
),

```Language change
final localizationController = Get.find<LocalizationController>();
ElevatedButton(
  onPressed: () {
    localizationController.showLanguageBottomSheet(context);
  },
  child: Text('change_language'.tr, style: TextStyle(color: Colors.white)),
),
