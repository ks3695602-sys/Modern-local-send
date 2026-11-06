import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import '../../../models/file_item.dart';
import '../../../state/app_state.dart';
import '../transfer/transfer_modal_sheet.dart';
import 'widgets/radar_scan_view.dart';
import 'widgets/selection_platter.dart';

class SendScreen extends StatelessWidget {
  const SendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final discovery = appState.discoveryService;
    final transfer = appState.transferService;
    final selectedFiles = transfer.selectedFiles;
    final devices = discovery.devices;

    return GlassSwipeActionScope(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // 1. Radar Beacon Status
          RadarScanView(
            isScanning: discovery.isScanning,
            onRefresh: discovery.startScanning,
            deviceCount: devices.length,
          ),

          const SizedBox(height: 8),

          // 2. Selection Platter (Floating Glass Buttons for picking content)
          SelectionPlatter(
            onActionSelected: (type) => _handleSelectionAction(context, type, appState),
          ),

          const SizedBox(height: 14),

          // 3. Selected Files Queue (if any)
          if (selectedFiles.isNotEmpty) ...[
            _buildSelectedFilesHeader(context, transfer),
            const SizedBox(height: 8),
            _buildSelectedFilesList(transfer),
            const SizedBox(height: 18),
          ],

          // 4. Discovered Nearby Devices (Native iOS Inset-Grouped Solid Section)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text(
                  'NEARBY DEVICES',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white54,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _showManualIpDialog(context, appState),
                child: const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Text(
                    '+ Manual IP',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF007AFF),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          GlassGroupedSection(
            surfaceStyle: GlassSurfaceStyle.solid,
            children: devices.map((device) {
              return GlassListTile(
                leading: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: device.accentColor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    device.icon,
                    color: device.accentColor,
                    size: 20,
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        device.alias,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (device.isFavorite) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        CupertinoIcons.star_fill,
                        color: Color(0xFFFFCC00),
                        size: 14,
                      ),
                    ],
                  ],
                ),
                subtitle: Text(
                  '${device.ip} • ${device.deviceModel} • ${device.pingMs}ms',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
                trailing: const Icon(
                  CupertinoIcons.paperplane,
                  color: Color(0xFF007AFF),
                  size: 20,
                ),
                trailingSwipeActions: [
                  GlassSwipeAction(
                    icon: Icon(
                      device.isFavorite ? CupertinoIcons.star_slash : CupertinoIcons.star,
                      color: Colors.white,
                    ),
                    label: Text(device.isFavorite ? 'Unfavorite' : 'Favorite'),
                    onTap: () => discovery.toggleFavorite(device.id),
                  ),
                ],
                onTap: () {
                  if (selectedFiles.isEmpty) {
                    _showToast(context, 'Please select files first above');
                  } else {
                    transfer.startTransfer(device);
                    TransferModalSheet.show(context);
                  }
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 80), // Padding for bottom tab bar
        ],
      ),
    );
  }

  Widget _buildSelectedFilesHeader(BuildContext context, dynamic transfer) {
    final totalSize = transfer.selectedFiles.fold<int>(0, (sum, f) => sum + f.size);
    final formattedTotal = _formatBytes(totalSize);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'SELECTED (${transfer.selectedFiles.length}) • $formattedTotal',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white54,
              letterSpacing: 0.8,
            ),
          ),
          GestureDetector(
            onTap: transfer.clearSelectedFiles,
            child: const Text(
              'Clear All',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFF453A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedFilesList(dynamic transfer) {
    return GlassGroupedSection(
      surfaceStyle: GlassSurfaceStyle.solid,
      children: transfer.selectedFiles.map<Widget>((FileItem file) {
        return GlassListTile(
          leading: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: file.badgeColor.withOpacity(0.20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(file.icon, size: 16, color: file.badgeColor),
          ),
          title: Text(
            file.name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            file.formattedSize,
            style: const TextStyle(fontSize: 12, color: Colors.white54),
          ),
          trailing: GestureDetector(
            onTap: () => transfer.removeFile(file.id),
            child: const Icon(CupertinoIcons.xmark_circle_fill, color: Colors.white38, size: 18),
          ),
        );
      }).toList(),
    );
  }

  void _handleSelectionAction(BuildContext context, SelectionActionType type, AppState appState) {
    switch (type) {
      case SelectionActionType.files:
        appState.transferService.addFiles([
          FileItem(
            id: 'file_${DateTime.now().millisecondsSinceEpoch}_1',
            name: 'Android_SDK_35_System_Image.tar.gz',
            size: 420 * 1024 * 1024,
            type: FileItemType.archive,
          ),
        ]);
        _showToast(context, 'Added Archive (420 MB) to queue');
        break;
      case SelectionActionType.media:
        appState.transferService.addFiles([
          FileItem(
            id: 'file_${DateTime.now().millisecondsSinceEpoch}_2',
            name: 'Sunset_Impeller_HDR.heic',
            size: 12 * 1024 * 1024,
            type: FileItemType.image,
          ),
          FileItem(
            id: 'file_${DateTime.now().millisecondsSinceEpoch}_3',
            name: 'Drone_Footage_4K_60FPS.mp4',
            size: 310 * 1024 * 1024,
            type: FileItemType.video,
          ),
        ]);
        _showToast(context, 'Added 2 media files to queue');
        break;
      case SelectionActionType.text:
        _showTextShareDialog(context, appState);
        break;
      case SelectionActionType.folder:
        appState.transferService.addFiles([
          FileItem(
            id: 'file_${DateTime.now().millisecondsSinceEpoch}_4',
            name: 'Projects_Source_Code.zip',
            size: 85 * 1024 * 1024,
            type: FileItemType.archive,
          ),
        ]);
        _showToast(context, 'Zipped and added folder to queue');
        break;
      case SelectionActionType.app:
        appState.transferService.addFiles([
          FileItem(
            id: 'file_${DateTime.now().millisecondsSinceEpoch}_5',
            name: 'ModernLocalSend_v2.0.apk',
            size: 46 * 1024 * 1024,
            type: FileItemType.apk,
          ),
        ]);
        _showToast(context, 'Extracted and added APK to queue');
        break;
      case SelectionActionType.clipboard:
        appState.transferService.addFiles([
          FileItem(
            id: 'file_${DateTime.now().millisecondsSinceEpoch}_6',
            name: 'Clipboard_Message.txt',
            size: 4 * 1024,
            type: FileItemType.text,
          ),
        ]);
        _showToast(context, 'Added clipboard content to queue');
        break;
    }
  }

  void _showTextShareDialog(BuildContext context, AppState appState) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Send Text / Message', style: TextStyle(color: Colors.white, fontSize: 17)),
        content: TextField(
          controller: textController,
          maxLines: 4,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Type text or paste URL...',
            hintStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: Colors.white.withOpacity(0.08),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              final content = textController.text.trim();
              if (content.isNotEmpty) {
                appState.transferService.addFiles([
                  FileItem(
                    id: 'text_${DateTime.now().millisecondsSinceEpoch}',
                    name: content.length > 20 ? '${content.substring(0, 20)}....txt' : '$content.txt',
                    size: content.length,
                    type: FileItemType.text,
                  ),
                ]);
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Add to Queue', style: TextStyle(color: Color(0xFF007AFF), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showManualIpDialog(BuildContext context, AppState appState) {
    final ipController = TextEditingController(text: '192.168.1.');
    final portController = TextEditingController(text: '53317');
    final aliasController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Connect to IP', style: TextStyle(color: Colors.white, fontSize: 17)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ipController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'IP Address',
                labelStyle: const TextStyle(color: Colors.white60),
                filled: true,
                fillColor: Colors.white.withOpacity(0.08),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: portController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Port (default: 53317)',
                labelStyle: const TextStyle(color: Colors.white60),
                filled: true,
                fillColor: Colors.white.withOpacity(0.08),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: aliasController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Alias (Optional)',
                labelStyle: const TextStyle(color: Colors.white60),
                filled: true,
                fillColor: Colors.white.withOpacity(0.08),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              final ip = ipController.text.trim();
              final port = int.tryParse(portController.text.trim()) ?? 53317;
              final alias = aliasController.text.trim();
              if (ip.isNotEmpty) {
                appState.discoveryService.addManualDevice(ip, port, alias);
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Connect', style: TextStyle(color: Color(0xFF007AFF), fontWeight: FontWeight.bold)),
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

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
