import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import '../../../models/app_settings.dart';
import '../../../state/app_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _aliasController;

  @override
  void initState() {
    super.initState();
    _aliasController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appState = AppStateProvider.of(context);
    if (_aliasController.text.isEmpty) {
      _aliasController.text = appState.settings.deviceAlias;
    }
  }

  @override
  void dispose() {
    _aliasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final settings = appState.settings;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // 1. DEVICE IDENTITY & LOCAL NETWORK
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            'DEVICE IDENTITY',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white54,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 8),

        GlassGroupedSection(
          surfaceStyle: GlassSurfaceStyle.solid,
          children: [
            GlassListTile(
              leading: const Icon(CupertinoIcons.pencil_ellipsis_rectangle, color: Color(0xFF007AFF)),
              title: const Text('Device Alias', style: TextStyle(color: Colors.white)),
              subtitle: GlassTextField(
                controller: _aliasController,
                placeholder: 'Enter device name',
                onChanged: appState.setDeviceAlias,
              ),
            ),
            GlassListTile(
              leading: const Icon(CupertinoIcons.antenna_radiowaves_left_right, color: Color(0xFF5856D6)),
              title: const Text('Port', style: TextStyle(color: Colors.white)),
              trailing: Text(
                '${settings.port}',
                style: const TextStyle(color: Colors.white60, fontSize: 15),
              ),
            ),
            GlassListTile(
              leading: const Icon(CupertinoIcons.rectangle_stack_person_crop, color: Color(0xFFFF9500)),
              title: const Text('Multicast Group', style: TextStyle(color: Colors.white)),
              trailing: Text(
                settings.multicastGroup,
                style: const TextStyle(color: Colors.white60, fontSize: 15),
              ),
            ),
            GlassListTile(
              leading: const Icon(CupertinoIcons.lock_shield, color: Color(0xFF34C759)),
              title: const Text('TLS Encryption', style: TextStyle(color: Colors.white)),
              subtitle: const Text('HTTPS secure socket transfers', style: TextStyle(color: Colors.white54, fontSize: 12)),
              trailing: GlassSwitch(
                value: settings.encryption,
                onChanged: appState.toggleEncryption,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 2. LIQUID GLASS OPTICS & SHADERS
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            'LIQUID GLASS OPTICS (iOS 26/27)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white54,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 8),

        GlassGroupedSection(
          surfaceStyle: GlassSurfaceStyle.solid,
          children: [
            GlassListTile(
              leading: const Icon(CupertinoIcons.sparkles, color: Color(0xFFAF52DE)),
              title: const Text('Glass Style Preset', style: TextStyle(color: Colors.white)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 4),
                child: GlassSegmentedControl(
                  segments: const ['iOS 27', 'iOS 26', 'Classic'],
                  selectedIndex: settings.glassPreset == GlassDesignPreset.ios27
                      ? 0
                      : (settings.glassPreset == GlassDesignPreset.ios26 ? 1 : 2),
                  onSegmentSelected: (index) {
                    if (index == 0) {
                      appState.setGlassPreset(GlassDesignPreset.ios27);
                    } else if (index == 1) {
                      appState.setGlassPreset(GlassDesignPreset.ios26);
                    } else {
                      appState.setGlassPreset(GlassDesignPreset.classic);
                    }
                  },
                ),
              ),
            ),
            GlassListTile(
              leading: const Icon(CupertinoIcons.sun_max_fill, color: Color(0xFFFFCC00)),
              title: const Text('Specular Sharpness', style: TextStyle(color: Colors.white)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 4),
                child: GlassSegmentedControl(
                  segments: const ['Soft', 'Medium', 'Sharp'],
                  selectedIndex: settings.sharpnessMode == SpecularSharpnessMode.soft
                      ? 0
                      : (settings.sharpnessMode == SpecularSharpnessMode.medium ? 1 : 2),
                  onSegmentSelected: (index) {
                    if (index == 0) {
                      appState.setSharpness(SpecularSharpnessMode.soft);
                    } else if (index == 1) {
                      appState.setSharpness(SpecularSharpnessMode.medium);
                    } else {
                      appState.setSharpness(SpecularSharpnessMode.sharp);
                    }
                  },
                ),
              ),
            ),
            GlassListTile(
              leading: const Icon(CupertinoIcons.speedometer, color: Color(0xFF34C759)),
              title: const Text('Adaptive Quality', style: TextStyle(color: Colors.white)),
              subtitle: const Text(
                'Auto-benchmarks device GPU raster budget (60/120fps)',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              trailing: GlassSwitch(
                value: settings.adaptiveQuality,
                onChanged: appState.toggleAdaptiveQuality,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 3. ANDROID ENGINE & STORAGE
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            'ANDROID SYSTEM INTEGRATION',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white54,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 8),

        GlassGroupedSection(
          surfaceStyle: GlassSurfaceStyle.solid,
          children: [
            const GlassListTile(
              leading: Icon(CupertinoIcons.device_desktop, color: Color(0xFF32ADE6)),
              title: Text('Graphics Pipeline', style: TextStyle(color: Colors.white)),
              subtitle: Text('Impeller Vulkan (Optimized 16-shape AST)', style: TextStyle(color: Colors.white54, fontSize: 12)),
              trailing: Icon(CupertinoIcons.checkmark_seal_fill, color: Color(0xFF34C759), size: 18),
            ),
            GlassListTile(
              leading: const Icon(CupertinoIcons.folder, color: Color(0xFFFF9500)),
              title: const Text('Save Location', style: TextStyle(color: Colors.white)),
              subtitle: Text(settings.downloadDirectory, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              trailing: GlassListTile.chevron,
            ),
            const GlassListTile(
              leading: Icon(CupertinoIcons.eye_fill, color: Color(0xFF5856D6)),
              title: Text('WCAG Accessibility', style: TextStyle(color: Colors.white)),
              subtitle: Text('Reduce Motion & High Contrast auto-bridge enabled', style: TextStyle(color: Colors.white54, fontSize: 12)),
              trailing: Icon(CupertinoIcons.checkmark_alt, color: Color(0xFF34C759), size: 18),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 4. ABOUT
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            'ABOUT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white54,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 8),

        GlassGroupedSection(
          surfaceStyle: GlassSurfaceStyle.solid,
          children: [
            const GlassListTile(
              title: Text('Modern LocalSend', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text('v2.0.0 (Liquid Glass Edition)', style: TextStyle(color: Colors.white54)),
              trailing: Text('Android', style: TextStyle(color: Colors.white38)),
            ),
            const GlassListTile(
              title: Text('Protocol Compatibility', style: TextStyle(color: Colors.white)),
              subtitle: Text('Full interoperability with standard LocalSend v2 clients', style: TextStyle(color: Colors.white54)),
              trailing: Icon(CupertinoIcons.check_mark, color: Color(0xFF34C759), size: 16),
            ),
            GlassListTile(
              title: const Text('Source Code License', style: TextStyle(color: Colors.white)),
              subtitle: const Text('MIT License • Open Source', style: TextStyle(color: Colors.white54)),
              trailing: GlassListTile.chevron,
              onTap: () {
                _showLicenseDialog(context);
              },
            ),
          ],
        ),

        const SizedBox(height: 80),
      ],
    );
  }

  void _showLicenseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Modern LocalSend License', style: TextStyle(color: Colors.white)),
        content: const Text(
          'MIT License\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files.\n\nPowered by LocalSend architecture & liquid_glass_widgets.',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close', style: TextStyle(color: Color(0xFF007AFF))),
          ),
        ],
      ),
    );
  }
}
