import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import '../screens/receive/receive_screen.dart';
import '../screens/send/send_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../widgets/ambient_mesh_background.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedTab = 0;

  final List<Widget> _screens = const [
    SendScreen(),
    ReceiveScreen(),
    SettingsScreen(),
  ];

  String get _appBarTitle {
    switch (_selectedTab) {
      case 0:
        return 'Send & Share';
      case 1:
        return 'Receive Files';
      case 2:
        return 'Settings';
      default:
        return 'Modern LocalSend';
    }
  }

  @override
  Widget build(BuildContext context) {
    // GlassScaffold wires background, glass rendering layers, edge fading,
    // and bar z-ordering automatically (Rule 3)
    return GlassScaffold(
      // 1. Wallpaper background for glass refraction and chromatic aberration
      background: const AmbientMeshBackground(),
      contentAwareBrightness: true,
      statusBarStyle: GlassStatusBarStyle.light,

      // 2. Navigation Chrome (GlassAppBar)
      // GlassAppBar uses `actions` (List<Widget>), not trailing
      appBar: GlassAppBar(
        title: Text(
          _appBarTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          // GlassIconButton uses onPressed
          GlassIconButton(
            icon: const Icon(CupertinoIcons.qrcode_viewfinder, size: 20),
            onPressed: () => _showQrScanner(context),
          ),
          const SizedBox(width: 8),
          GlassIconButton(
            icon: const Icon(CupertinoIcons.question_circle, size: 20),
            onPressed: () => _showHelpDialog(context),
          ),
          const SizedBox(width: 12),
        ],
      ),

      // 3. Bottom Glass Navigation Pill
      // Uses GlassTabBar.bottom (GlassBottomBar is deleted in 1.x)
      bottomBar: GlassTabBar.bottom(
        selectedIndex: _selectedTab,
        onTabSelected: (index) => setState(() => _selectedTab = index),
        tabs: const [
          GlassTab(
            icon: Icon(CupertinoIcons.paperplane_fill),
            label: 'Send',
          ),
          GlassTab(
            icon: Icon(CupertinoIcons.tray_fill),
            label: 'Receive',
          ),
          GlassTab(
            icon: Icon(CupertinoIcons.gear_alt_fill),
            label: 'Settings',
          ),
        ],
      ),

      // 4. Content Screen
      body: IndexedStack(
        index: _selectedTab,
        children: _screens,
      ),
    );
  }

  void _showQrScanner(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Local QR Connect', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(CupertinoIcons.qrcode, size: 140, color: Colors.black),
            ),
            const SizedBox(height: 14),
            const Text(
              'Scan this QR code from another device on the same WiFi network to connect instantly.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
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

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('How to Transfer', style: TextStyle(color: Colors.white)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. Ensure both devices are on the same WiFi / LAN network.\n'
              '2. Select files, photos, or text from the top platter.\n'
              '3. Tap any discovered device in the list to initiate transfer.\n'
              '4. Fast, secure P2P transfers without internet access.',
              style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Got it', style: TextStyle(color: Color(0xFF007AFF))),
          ),
        ],
      ),
    );
  }
}
