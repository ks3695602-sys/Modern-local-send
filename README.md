# Modern LocalSend (Liquid Glass Edition)

<p align="center">
  <img src="https://raw.githubusercontent.com/localsend/localsend/main/assets/img/logo-512.png" width="96" height="96" alt="LocalSend Logo" />
</p>

<p align="center">
  <b>The open-source, local peer-to-peer file sharing powerhouse — redesigned with Apple iOS 26/27 Liquid Glass optics, real GPU fragment shaders, and physics-driven animations for Android.</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-%E2%89%A53.41.0-blue.svg?logo=flutter" alt="Flutter Version" />
  <img src="https://img.shields.io/badge/Dart-%E2%89%A53.5.0-0175C2.svg?logo=dart" alt="Dart Version" />
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20Cross--Platform-green.svg?logo=android" alt="Platform" />
  <img src="https://img.shields.io/badge/Optics-Liquid%20Glass%20iOS%2027-purple.svg" alt="Optics" />
  <img src="https://img.shields.io/badge/License-MIT-orange.svg" alt="License" />
</p>

---

## 🌟 Highlights

**Modern LocalSend** fuses the rock-solid, cross-platform local networking architecture of [LocalSend](https://localsend.org) with the next-generation visual design language of **`liquid_glass_widgets`** (Apple iOS 26 & iOS 27 Liquid Glass).

- ⚡ **LocalSend P2P Protocol**: Fast, secure LAN file transfers over WiFi/Ethernet without internet access, third-party servers, or speed throttling.
- 🔮 **True Impeller Fragment Shaders**: Real optical refraction, chromatic dispersion, specular highlights, and edge lighting across navigation chrome.
- 📱 **Engineered for Android**: Tuned for Android Impeller Vulkan (16-shape unrolled geometry pipeline) with zero-cost GLES fallback, zero-blocking Frame 1 async preloading, and edge-to-edge support.
- 📐 **Strict Human Interface Guidelines**: Implements the golden rule: **"Glass is a Platter, Not a Wrapper"** — floating glass chrome for navigation and controls paired with native opaque inset-grouped solid cards for content.
- 🤖 **Built-in AI Coding Skill**: Bundled with `.agents/skills/liquid-glass-widgets/SKILL.md` to guide AI agents and prevent API hallucinations.

---

## 📱 Redesigned Screens & Widgets

```
┌────────────────────────────────────────────────────────┐
│  GlassAppBar: "Send & Share"      [QR] [Help]  (Glass) │
├────────────────────────────────────────────────────────┤
│  RadarScanView: Active UDP Beacon (224.0.0.167:53317)  │
│                                                        │
│  [Files] [Photos] [Text] [Folder] [App APK] [Clip]     │  ← GlassButton Platter
│                                                        │
│  NEARBY DEVICES                                        │
│  ┌──────────────────────────────────────────────────┐  │
│  │ 📱 Pixel 9 Pro (Living Room)      [Send]         │  │
│  │ 💻 Mac Studio (Workstation)       [Send]         │  │  ← GlassGroupedSection
│  │ 📱 iPad Air 13"                   [Send]         │  │    (surfaceStyle: solid)
│  │ 🖥️ Aurora Windows Rig             [Send]         │  │    + GlassListTile
│  └──────────────────────────────────────────────────┘  │    + GlassSwipeActions
├────────────────────────────────────────────────────────┤
│  GlassTabBar.bottom: [ Send | Receive | Settings ]     │  ← Glass Navigation
└────────────────────────────────────────────────────────┘
```

### 1. Send & Share
- **Floating Selection Platter**: Quick-pick action capsules (`Files`, `Photos`, `Text`, `Folder`, `App APK`, `Clipboard`) built with tactile `GlassButton` widgets on the page platter.
- **Subnet Radar Beacon**: Real-time pulsing beacon displaying active multicast discovery (`224.0.0.167:53317`) and active peer count.
- **Selected File Queue**: Instant size tally, item removal, and one-tap send trigger.
- **Discovered Peers**: Formatted as native iOS inset-grouped cards (`GlassGroupedSection(surfaceStyle: GlassSurfaceStyle.solid)`), with device badges, ping latency, and swipe-to-favorite actions (`GlassSwipeActions`).

### 2. Receive
- **Server Beacon Card**: High-contrast, clean status card highlighting active IP (`192.168.1.105:53317`) and reception readiness.
- **Quick Save Toggle**: Fluid `GlassSwitch` allowing instant automatic downloads without pop-up prompts.
- **Transfer History**: Inset-grouped list of recent incoming files with swipe actions for **Delete** and **Share**.

### 3. Settings (iOS 26/27 Aesthetics)
- **Device Identity**: Customizable device alias via `GlassTextField`.
- **Liquid Glass Optics**:
  - **Preset Selection**: `GlassSegmentedControl` switching between **iOS 27 (Paraxial Lens)**, **iOS 26**, and **Classic**.
  - **Specular Sharpness**: Switch between **Soft**, **Medium**, and **Sharp** highlights.
  - **Adaptive Quality**: Dynamic raster frame benchmarking (maintains silky 60/120 fps).
- **System & Security**: Port configuration, TLS HTTPS encryption toggle, and download path selector.

### 4. Fluid Transfer Modal Sheet
- Built with `GlassModalSheet.show()` featuring spring-physics detents.
- Live throughput display (e.g., `45.8 MB/s`), animated progress, remaining ETA, and cancellation controls.

---

## 🎨 Golden Design Rules Followed

1. **Glass is a Platter, Not a Wrapper**:
   - Glass is reserved for floating chrome: `GlassAppBar`, `GlassTabBar.bottom`, `GlassModalSheet`, and floating action `GlassButton`s.
   - List cells and scrollable cards use `GlassGroupedSection(surfaceStyle: GlassSurfaceStyle.solid)` for maximum contrast, zero double-refraction distortion, and optimal battery efficiency.
2. **Never Nest Refractive Glass in Refractive Glass**:
   - `GlassButton`, `GlassIconButton`, and `GlassChip` are never placed inside a default glass card.
   - `GlassSwitch` and `GlassSegmentedControl` are placed inside solid sections where their glass only appears while touched.
3. **Android Impeller Optimization**:
   - `LiquidGlassWidgets.initialize()` pre-warms shaders using non-blocking async disk-to-RAM I/O before `runApp()`.
   - On Android devices with Impeller Vulkan, shaders execute the full 16-shape pipeline matching iOS Metal frame-for-frame.

---

## 🛠️ Project Structure

```
Modern local send/
├── .agents/
│   └── skills/
│       └── liquid-glass-widgets/
│           └── SKILL.md            # Official AI Agent Guidelines
├── android/
│   ├── app/
│   │   ├── build.gradle            # Android Gradle Configuration (SDK 35)
│   │   └── src/main/
│   │       ├── AndroidManifest.xml # Multicast, WiFi, and Storage Permissions
│   │       └── kotlin/org/localsend/modern_localsend/MainActivity.kt
│   ├── build.gradle
│   ├── settings.gradle
│   └── gradle.properties
├── assets/
│   └── images/
│       ├── wallpaper.jpg           # Light refraction wallpaper
│       └── wallpaper_dark.jpg      # Ambient dark refraction wallpaper
├── lib/
│   ├── main.dart                   # Shader init & LiquidGlassWidgets.wrap
│   ├── app.dart                    # App wrapper & Material transparency bridge
│   ├── models/
│   │   ├── device.dart             # Peer device model
│   │   ├── file_item.dart          # File queue & detection model
│   │   ├── transfer_session.dart   # Live session & speed metrics
│   │   └── app_settings.dart       # Preferences & Glass presets
│   ├── services/
│   │   ├── discovery_service.dart  # UDP Multicast beacon scanning
│   │   └── transfer_service.dart   # P2P Transfer pipeline & history
│   ├── state/
│   │   └── app_state.dart          # Central reactive provider
│   └── ui/
│       ├── navigation/
│       │   └── main_shell.dart     # GlassScaffold + GlassAppBar + GlassTabBar
│       ├── screens/
│       │   ├── send/
│       │   │   ├── send_screen.dart
│       │   │   └── widgets/
│       │   │       ├── radar_scan_view.dart
│       │   │       └── selection_platter.dart
│       │   ├── receive/
│       │   │   └── receive_screen.dart
│       │   ├── settings/
│       │   │   └── settings_screen.dart
│       │   └── transfer/
│       │       └── transfer_modal_sheet.dart
│       └── widgets/
│           └── ambient_mesh_background.dart
├── pubspec.yaml
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: `>= 3.41.0` (with Impeller support recommended)
- **Dart SDK**: `>= 3.5.0`
- **Android Studio / Android SDK**: API Level 34 or 35

### Run on Android
```bash
# 1. Fetch dependencies
flutter pub get

# 2. Run on connected Android device or emulator with Impeller enabled
flutter run -d android
```

### Build Android APK
```bash
flutter build apk --release
```

---

## 📜 License & Acknowledgments

- **LocalSend**: Original local peer-to-peer sharing protocol and cross-platform concept created by [Tien Do Nam](https://github.com/Tienisto) and the LocalSend community (MIT License).
- **Liquid Glass Widgets**: iOS 26/27 shader-based glassmorphism library by [sdegenaar](https://github.com/sdegenaar/liquid_glass_widgets) (MIT License).
- **Modern LocalSend**: Licensed under the [MIT License](LICENSE).
