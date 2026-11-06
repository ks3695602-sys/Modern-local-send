import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

enum SelectionActionType {
  files,
  media,
  text,
  folder,
  app,
  clipboard,
}

class SelectionPlatter extends StatelessWidget {
  final ValueChanged<SelectionActionType> onActionSelected;

  const SelectionPlatter({
    super.key,
    required this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildItem(
            icon: CupertinoIcons.doc_fill,
            label: 'Files',
            color: const Color(0xFF007AFF),
            onTap: () => onActionSelected(SelectionActionType.files),
          ),
          const SizedBox(width: 10),
          _buildItem(
            icon: CupertinoIcons.photo_fill,
            label: 'Photos',
            color: const Color(0xFFFF2D55),
            onTap: () => onActionSelected(SelectionActionType.media),
          ),
          const SizedBox(width: 10),
          _buildItem(
            icon: CupertinoIcons.quote_bubble_fill,
            label: 'Text',
            color: const Color(0xFF32ADE6),
            onTap: () => onActionSelected(SelectionActionType.text),
          ),
          const SizedBox(width: 10),
          _buildItem(
            icon: CupertinoIcons.folder_fill,
            label: 'Folder',
            color: const Color(0xFFFF9500),
            onTap: () => onActionSelected(SelectionActionType.folder),
          ),
          const SizedBox(width: 10),
          _buildItem(
            icon: CupertinoIcons.app_badge_fill,
            label: 'App (APK)',
            color: const Color(0xFF34C759),
            onTap: () => onActionSelected(SelectionActionType.app),
          ),
          const SizedBox(width: 10),
          _buildItem(
            icon: CupertinoIcons.doc_on_clipboard_fill,
            label: 'Clipboard',
            color: const Color(0xFFAF52DE),
            onTap: () => onActionSelected(SelectionActionType.clipboard),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    // GlassButton sits directly on the page platter (Rule 2)
    // Note: GlassButton uses onTap, not onPressed
    return GlassButton(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: color.withOpacity(0.20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 14,
                color: color,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: -0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
