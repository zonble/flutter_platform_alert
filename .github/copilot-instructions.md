# GitHub Copilot Instructions for flutter_platform_alert

## Project Overview

`flutter_platform_alert` is a Flutter plugin that bridges native platform APIs to:

1. **Play alert sounds** – using the system's native audio APIs.
2. **Show native alert dialogs** – using each platform's native dialog API.

### Supported Platforms and Their Native APIs

| Platform | Sound API | Dialog API |
|----------|-----------|------------|
| Android | `RingtoneManager` | `AlertDialog` (Material Design) |
| iOS | `AudioServices` | `UIAlertController` |
| macOS | `NSSound.beep()` | `NSAlert` |
| Windows | `MessageBeep()` | `MessageBox` / `TaskDialogIndirect` |
| Linux | `gtk_widget_error_bell()` | `GtkMessageDialog` |

---

## Repository Layout

```
flutter_platform_alert/
├── lib/
│   ├── flutter_platform_alert.dart        # Public export barrel file
│   └── src/
│       ├── flutter_platform_alert.dart    # Main class (MethodChannel calls)
│       ├── alert_button.dart              # AlertButton / CustomButton enums
│       ├── helpers.dart                   # Enum ↔ string conversion helpers
│       ├── window_position.dart           # AlertWindowPosition enum
│       ├── alert_options/
│       │   ├── platform_alert_options.dart  # Platform-routing options class
│       │   ├── ios_alert_options.dart
│       │   ├── android_alert_options.dart
│       │   ├── macos_alert_options.dart
│       │   └── windows_alert_options.dart
│       └── styles/
│           ├── alert_style.dart           # AlertButtonStyle enum
│           ├── icon_style.dart            # IconStyle enum
│           ├── ios_alert_style.dart       # IosAlertStyle enum
│           └── ios_button_style.dart      # IosButtonStyle enum
├── android/   # Kotlin implementation
├── ios/       # Swift implementation (SPM-compatible)
├── macos/     # Swift implementation (SPM-compatible)
├── windows/   # C++ implementation
├── linux/     # C implementation (GTK3)
├── example/   # Example Flutter app demonstrating all features
├── pubspec.yaml
└── analysis_options.yaml
```

---

## Dart / Flutter Public API

### `FlutterPlatformAlert` (static class)

All public methods are `static` and `async`. The class cannot be instantiated.

```dart
// Play the system alert sound.
static Future<void> playAlertSound({
  IconStyle iconStyle = IconStyle.none,
})

// Show a standard platform alert with predefined button sets.
// Returns the button the user clicked.
static Future<AlertButton> showAlert({
  required String windowTitle,
  required String text,
  AlertButtonStyle alertStyle = AlertButtonStyle.ok,
  IconStyle iconStyle = IconStyle.none,
  PlatformAlertOptions? options,
  AlertWindowPosition windowPosition = AlertWindowPosition.parentWindowCenter,
})

// Show a platform alert with fully customised button labels.
// Returns the button the user clicked.
static Future<CustomButton> showCustomAlert({
  required String windowTitle,
  required String text,
  IconStyle iconStyle = IconStyle.none,
  String? positiveButtonTitle,
  String? negativeButtonTitle,
  String? neutralButtonTitle,
  PlatformAlertOptions? options,
  AlertWindowPosition windowPosition = AlertWindowPosition.parentWindowCenter,
  String iconPath = '',   // Flutter asset path; only ICO format is supported on Windows
})
```

### Key Enums

| Enum | Values |
|------|--------|
| `AlertButton` | `abortButton`, `cancelButton`, `continueButton`, `ignoreButton`, `noButton`, `okButton`, `retryButton`, `tryAgainButton`, `yesButton`, `other` |
| `CustomButton` | `positiveButton`, `negativeButton`, `neutralButton`, `other` |
| `AlertButtonStyle` | `abortRetryIgnore`, `cancelTryContinue`, `ok`, `okCancel`, `retryCancel`, `yesNo`, `yesNoCancel` |
| `IconStyle` | `none`, `exclamation`, `warning`, `information`, `asterisk`, `question`, `stop`, `error`, `hand` |
| `IosAlertStyle` | `alertDialog`, `actionSheet` |
| `IosButtonStyle` | `cancel`, `destructive`, `normal` |
| `AlertWindowPosition` | `parentWindowCenter`, `screenCenter` |

### Platform-Specific Options

All options are passed through `PlatformAlertOptions`, which routes to the correct platform at runtime via `Platform.isX` checks:

```dart
PlatformAlertOptions({
  IosAlertOptions? ios,
  MacosAlertOptions? macos,
  WindowsAlertOptions? windows,
  AndroidAlertOptions? android,
})
```

Each options class exposes a `toJson()` method that serialises fields for the `MethodChannel` call.

---

## MethodChannel Protocol

The Dart layer communicates with native code over the channel named **`flutter_platform_alert`**.

### Method: `playAlertSound`
```json
{ "iconStyle": "<IconStyle.name>" }
```

### Method: `showAlert`
```json
{
  "windowTitle": "string",
  "text": "string",
  "alertStyle": "<AlertButtonStyle.stringValue>",
  "iconStyle": "<IconStyle.stringValue>",
  "position": 0,
  // ...platform options flattened from PlatformAlertOptions.toJson()
}
```

### Method: `showCustomAlert`
```json
{
  "windowTitle": "string",
  "text": "string",
  "iconStyle": "<IconStyle.name>",
  "positiveButtonTitle": "string",
  "negativeButtonTitle": "string",
  "neutralButtonTitle": "string",
  "position": 0,
  "iconPath": "/absolute/path/to/asset",
  "base64Icon": "<base64-encoded image>",
  // ...platform options flattened from PlatformAlertOptions.toJson()
}
```

### Return Values (string → enum mapping)

| String returned by native | Dart enum value |
|---------------------------|-----------------|
| `"ok"` | `AlertButton.okButton` |
| `"cancel"` | `AlertButton.cancelButton` |
| `"yes"` | `AlertButton.yesButton` |
| `"no"` | `AlertButton.noButton` |
| `"abort"` | `AlertButton.abortButton` |
| `"retry"` | `AlertButton.retryButton` |
| `"ignore"` | `AlertButton.ignoreButton` |
| `"continue"` | `AlertButton.continueButton` |
| `"try_again"` | `AlertButton.tryAgainButton` |
| `"positive_button"` | `CustomButton.positiveButton` |
| `"negative_button"` | `CustomButton.negativeButton` |
| `"neutral_button"` | `CustomButton.neutralButton` |

Any unrecognised string maps to `.other`.

---

## Platform Implementations

### Android (Kotlin)
- **Entry point:** `android/src/main/kotlin/net/zonble/flutter_platform_alert/FlutterPlatformAlertPlugin.kt`
- Uses `AlertDialog.Builder` for dialogs.
- Supports `cancelable` flag (via `AndroidAlertOptions`).
- Returns button identifiers via `MethodChannel.Result.success()`.
- Localised button labels live in `android/src/main/res/values*/strings.xml`.

### iOS (Swift)
- **Entry point:** `ios/flutter_platform_alert/Sources/flutter_platform_alert/FlutterPlatformAlertPlugin.swift`
- Uses `UIAlertController`; supports both `.alert` and `.actionSheet` styles.
- Button style maps to `UIAlertAction.Style` (`.default`, `.cancel`, `.destructive`).
- All UI work runs on the main thread via `DispatchQueue.main.async`.

### macOS (Swift)
- **Entry point:** `macos/flutter_platform_alert/Sources/flutter_platform_alert/FlutterPlatformAlertPlugin.swift`
- Uses `NSAlert` for dialogs.
- `isNegativeActionDestructive` (via `MacosAlertOptions`) styles the negative button with `.destructive` appearance.
- All UI work runs on the main thread.

### Windows (C++)
- **Entry point:** `windows/flutter_platform_alert_plugin.cpp`
- `showAlert` supports both `MessageBox` (when `preferMessageBox = true`) and `TaskDialogIndirect`.
- `showCustomAlert` always uses `TaskDialogIndirect`.
- `showAsLinks` enables `TDF_USE_COMMAND_LINKS` in TaskDialog.
- Custom icons are passed as a base64-encoded string and decoded in C++; only ICO format is supported.
- Strings are converted between UTF-8 and UTF-16 (`std::wstring`) for Win32 APIs.

### Linux (C with GTK3)
- **Entry point:** `linux/flutter_platform_alert_plugin.cc`
- Uses `GtkMessageDialog` for dialogs.
- Localisation handled with `gettext`; `.po` files live under `linux/`.
- Sound is played via `gtk_widget_error_bell()`.

---

## Dart Coding Conventions

- **Static utility classes** use a private constructor: `ClassName._();`
- **Enum-to-string** conversions are done with Dart `extension` methods returning a `stringValue` getter (see `helpers.dart`).
- **String-to-enum** conversions use static factory methods in `*Helper` classes (e.g., `AlertButtonHelper.fromString()`).
- **Options classes** implement `toJson()` returning `Map<String, Object>` and are spread (`...options.toJson()`) directly into the MethodChannel argument map.
- **Null safety** is fully enabled. Default values for optional parameters should be declared in the constructor signature.
- Follow `flutter_lints` rules as configured in `analysis_options.yaml`.
- Keep imports sorted (the project uses `import_sorter`).

---

## How to Extend the Plugin

### Adding a New Platform Option Field

1. Add the field to the relevant options class (e.g., `WindowsAlertOptions`).
2. Include it in that class's `toJson()` method.
3. Read the value in the native implementation (the key is the JSON field name).

### Adding a New Enum Value

1. Add the value to the Dart enum in `lib/src/`.
2. Update the `stringValue` extension in `helpers.dart` (Dart → string).
3. Update `*Helper.fromString()` in `helpers.dart` (string → Dart).
4. Handle the new string value in each native platform implementation.

### Adding a New Method

1. Add the `static Future<…> myMethod(…)` in `lib/src/flutter_platform_alert.dart`.
2. Export it from `lib/flutter_platform_alert.dart` if needed.
3. Implement the matching `case "myMethod":` handler in every native plugin class.
4. Document the method channel arguments in this file.

### Adding a New Platform

1. Create the platform directory and implement `FlutterPlatformAlertPlugin` following the existing patterns.
2. Register the plugin in `pubspec.yaml` under `flutter.plugin.platforms`.
3. Add a new options class (e.g., `FuchsiaAlertOptions`) and wire it into `PlatformAlertOptions`.
4. Add the platform build step to `.github/workflows/ci.yaml`.

---

## Testing

- **Widget tests** live in `example/test/widget_test.dart`.
- There are no unit tests for the plugin itself; correctness is validated by building the example app on each platform in CI.
- When adding Dart logic, add corresponding tests in `example/test/` using `flutter_test`.
- For MethodChannel testing, use `TestDefaultBinaryMessengerBinding` to mock the channel and validate the arguments sent.

---

## CI / CD

Defined in `.github/workflows/ci.yaml`:

- **Triggers:** push and pull request on any branch.
- **Matrix:** macOS, Windows, and Ubuntu runners × multiple Flutter versions (currently 3.19.x through the latest stable).
- **Checks per platform:**
  - Android APK build (all runners)
  - macOS app build + iOS simulator build (macOS runner only)
  - Linux app build (Ubuntu runner only)
  - Windows app build (Windows runner only)
- All builds target the `example/` app.

---

## Dependencies

Runtime:
- `path` (^1.8.0) – used to resolve the absolute path of Flutter asset icons.

Dev:
- `flutter_lints` – static analysis.
- `import_sorter` – enforces consistent import ordering.
- `pubspec_dependency_sorter` – enforces consistent dependency ordering.

No third-party dependencies are needed in native code; each platform uses only its standard SDK.

---

## Localisation Notes

- **Android:** Add translated button labels to `android/src/main/res/values-<locale>/strings.xml`.
- **iOS / macOS:** Swift code uses `NSLocalizedString`; add entries to `Localizable.strings` inside the platform bundle.
- **Linux:** Uses `gettext`; update `.po` files under `linux/`.
- **Windows:** Uses Win32 `MessageBox`/`TaskDialog` which are system-localised; custom button labels come from Dart and are passed as UTF-16 strings.
