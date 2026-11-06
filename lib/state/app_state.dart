import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../services/discovery_service.dart';
import '../services/transfer_service.dart';

class AppState extends ChangeNotifier {
  final DiscoveryService discoveryService = DiscoveryService();
  final TransferService transferService = TransferService();

  AppSettings _settings = const AppSettings(
    deviceAlias: 'Modern Pixel 9 Pro',
    port: 53317,
    multicastGroup: '224.0.0.167',
    quickSave: false,
    autoDiscover: true,
    encryption: true,
    glassPreset: GlassDesignPreset.ios27,
    sharpnessMode: SpecularSharpnessMode.medium,
    adaptiveQuality: true,
    motionLighting: false,
  );

  AppSettings get settings => _settings;

  AppState() {
    discoveryService.addListener(notifyListeners);
    transferService.addListener(notifyListeners);
  }

  void updateSettings(AppSettings newSettings) {
    _settings = newSettings;
    notifyListeners();
  }

  void toggleQuickSave(bool value) {
    _settings = _settings.copyWith(quickSave: value);
    notifyListeners();
  }

  void setDeviceAlias(String alias) {
    _settings = _settings.copyWith(deviceAlias: alias);
    notifyListeners();
  }

  void setGlassPreset(GlassDesignPreset preset) {
    _settings = _settings.copyWith(glassPreset: preset);
    notifyListeners();
  }

  void setSharpness(SpecularSharpnessMode mode) {
    _settings = _settings.copyWith(sharpnessMode: mode);
    notifyListeners();
  }

  void toggleAdaptiveQuality(bool value) {
    _settings = _settings.copyWith(adaptiveQuality: value);
    notifyListeners();
  }

  void toggleEncryption(bool value) {
    _settings = _settings.copyWith(encryption: value);
    notifyListeners();
  }

  @override
  void dispose() {
    discoveryService.removeListener(notifyListeners);
    transferService.removeListener(notifyListeners);
    discoveryService.dispose();
    transferService.dispose();
    super.dispose();
  }
}

class AppStateProvider extends InheritedNotifier<AppState> {
  const AppStateProvider({
    super.key,
    required AppState super.notifier,
    required super.child,
  });

  static AppState of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
    assert(provider != null, 'No AppStateProvider found in context');
    return provider!.notifier!;
  }
}
