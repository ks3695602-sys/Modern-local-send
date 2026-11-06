enum GlassDesignPreset {
  ios27,
  ios26,
  classic,
}

enum SpecularSharpnessMode {
  soft,
  medium,
  sharp,
}

class AppSettings {
  final String deviceAlias;
  final int port;
  final String multicastGroup;
  final bool quickSave;
  final bool autoDiscover;
  final bool encryption;
  final GlassDesignPreset glassPreset;
  final SpecularSharpnessMode sharpnessMode;
  final bool adaptiveQuality;
  final bool motionLighting;
  final String downloadDirectory;

  const AppSettings({
    required this.deviceAlias,
    this.port = 53317,
    this.multicastGroup = '224.0.0.167',
    this.quickSave = false,
    this.autoDiscover = true,
    this.encryption = true,
    this.glassPreset = GlassDesignPreset.ios27,
    this.sharpnessMode = SpecularSharpnessMode.medium,
    this.adaptiveQuality = true,
    this.motionLighting = false,
    this.downloadDirectory = '/storage/emulated/0/Download/LocalSend',
  });

  AppSettings copyWith({
    String? deviceAlias,
    int? port,
    String? multicastGroup,
    bool? quickSave,
    bool? autoDiscover,
    bool? encryption,
    GlassDesignPreset? glassPreset,
    SpecularSharpnessMode? sharpnessMode,
    bool? adaptiveQuality,
    bool? motionLighting,
    String? downloadDirectory,
  }) {
    return AppSettings(
      deviceAlias: deviceAlias ?? this.deviceAlias,
      port: port ?? this.port,
      multicastGroup: multicastGroup ?? this.multicastGroup,
      quickSave: quickSave ?? this.quickSave,
      autoDiscover: autoDiscover ?? this.autoDiscover,
      encryption: encryption ?? this.encryption,
      glassPreset: glassPreset ?? this.glassPreset,
      sharpnessMode: sharpnessMode ?? this.sharpnessMode,
      adaptiveQuality: adaptiveQuality ?? this.adaptiveQuality,
      motionLighting: motionLighting ?? this.motionLighting,
      downloadDirectory: downloadDirectory ?? this.downloadDirectory,
    );
  }
}
