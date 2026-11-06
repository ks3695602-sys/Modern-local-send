import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import '../../../models/file_item.dart';
import '../../../state/app_state.dart';

class ReceiveScreen extends StatelessWidget {
  const ReceiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final settings = appState.settings;
    final transfer = appState.transferService;
    final history = transfer.transferHistory;

    return GlassSwipeActionScope(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // 1. Server Status Card (Solid Inset Platter)
          _buildServerBeaconCard(context, settings, appState),

          const SizedBox(height: 18),

          // 2. Receiver Preferences
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Text(
              'RECEIVE SETTINGS',
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
                leading: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF34C759).withOpacity(0.20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(CupertinoIcons.bolt_fill, color: Color(0xFF34C759), size: 18),
                ),
                title: const Text('Quick Save', style: TextStyle(color: Colors.white)),
                subtitle: const Text(
                  'Automatically accept transfers from local network',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                trailing: GlassSwitch(
                  value: settings.quickSave,
                  onChanged: appState.toggleQuickSave,
                ),
              ),
              GlassListTile(
                leading: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF007AFF).withOpacity(0.20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(CupertinoIcons.folder_badge_plus, color: Color(0xFF007AFF), size: 18),
                ),
                title: const Text('Destination Folder', style: TextStyle(color: Colors.white)),
                subtitle: Text(
                  settings.downloadDirectory,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: GlassListTile.chevron,
                onTap: () {
                  _showToast(context, 'Saved in ${settings.downloadDirectory}');
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 3. Received Files History
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text(
                  'RECEIVED HISTORY',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white54,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              if (history.isNotEmpty)
                Text(
                  '${history.length} items',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),

          if (history.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              alignment: Alignment.center,
              child: const Column(
                children: [
                  Icon(CupertinoIcons.tray, color: Colors.white24, size: 48),
                  SizedBox(height: 12),
                  Text(
                    'No incoming transfers yet',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                ],
              ),
            )
          else
            GlassGroupedSection(
              surfaceStyle: GlassSurfaceStyle.solid,
              children: history.map<Widget>((FileItem item) {
                return GlassListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: item.badgeColor.withOpacity(0.20),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(item.icon, size: 18, color: item.badgeColor),
                  ),
                  title: Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${item.formattedSize} • Received just now',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ),
                  trailing: const Icon(
                    CupertinoIcons.checkmark_circle_fill,
                    color: Color(0xFF34C759),
                    size: 18,
                  ),
                  trailingSwipeActions: [
                    GlassSwipeAction(
                      icon: const Icon(CupertinoIcons.trash, color: Colors.white),
                      label: const Text('Delete'),
                      isDestructive: true,
                      onTap: () => transfer.deleteFromHistory(item.id),
                    ),
                    GlassSwipeAction(
                      icon: const Icon(CupertinoIcons.share, color: Colors.white),
                      label: const Text('Share'),
                      onTap: () {
                        _showToast(context, 'Sharing ${item.name}');
                      },
                    ),
                  ],
                  onTap: () {
                    _showToast(context, 'Opening ${item.name}');
                  },
                );
              }).toList(),
            ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildServerBeaconCard(BuildContext context, dynamic settings, AppState appState) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Animated pulsing server status badge
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF34C759),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF34C759).withOpacity(0.6),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'RECEIVER ONLINE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF34C759),
                  letterSpacing: 0.8,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Port ${settings.port}',
                  style: const TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF007AFF).withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  CupertinoIcons.device_phone_portrait,
                  color: Color(0xFF007AFF),
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      settings.deviceAlias,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      '192.168.1.105 (WiFi Local)',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(CupertinoIcons.antenna_radiowaves_left_right, size: 16, color: Colors.white70),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Ready for incoming transfers via LocalSend Protocol v2',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF1C1C1E),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
