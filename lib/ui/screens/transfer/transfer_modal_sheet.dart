import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import '../../../models/transfer_session.dart';
import '../../../state/app_state.dart';

class TransferModalSheet extends StatelessWidget {
  const TransferModalSheet({super.key});

  static Future<void> show(BuildContext context) {
    return GlassModalSheet.show(
      context: context,
      initialState: GlassSheetState.half,
      halfSize: 0.62,
      peekSize: 110.0,
      builder: (sheetContext) {
        return const TransferModalSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final session = appState.transferService.activeSession;

    if (session == null) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: const Center(
          child: Text(
            'No active transfer session',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    final isSending = session.direction == TransferDirection.send;
    final isDone = session.status == TransferSessionStatus.completed;
    final isCancelled = session.status == TransferSessionStatus.cancelled;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        // Top drag indicator is drawn automatically by GlassModalSheet
        const SizedBox(height: 8),

        // Session Header
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isDone
                      ? [const Color(0xFF34C759), const Color(0xFF30D158)]
                      : [const Color(0xFF007AFF), const Color(0xFF5856D6)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isDone ? const Color(0xFF34C759) : const Color(0xFF007AFF)).withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                isDone
                    ? CupertinoIcons.checkmark_alt
                    : (isSending ? CupertinoIcons.paperplane_fill : CupertinoIcons.tray_and_arrow_down_fill),
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isDone
                        ? 'Transfer Complete'
                        : (isSending ? 'Sending to ${session.peer.alias}' : 'Receiving from ${session.peer.alias}'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${session.peer.ip} • ${session.peer.deviceModel}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Progress Section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(session.overallProgress * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        session.formattedSpeed,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF007AFF),
                        ),
                      ),
                      Text(
                        'ETA ${session.etaString}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Linear Progress Indicator
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: session.overallProgress,
                  minHeight: 8,
                  backgroundColor: Colors.white.withOpacity(0.12),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDone ? const Color(0xFF34C759) : const Color(0xFF007AFF),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(session.transferredBytes / (1024 * 1024)).toStringAsFixed(1)} MB',
                    style: const TextStyle(fontSize: 12, color: Colors.white60),
                  ),
                  Text(
                    '${(session.totalBytes / (1024 * 1024)).toStringAsFixed(1)} MB',
                    style: const TextStyle(fontSize: 12, color: Colors.white60),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Files in this batch
        const Text(
          'FILES IN TRANSFER',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white54,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),

        ...session.files.map((file) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: file.badgeColor.withOpacity(0.20),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(file.icon, size: 16, color: file.badgeColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            file.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            file.formattedSize,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isDone)
                      const Icon(CupertinoIcons.checkmark_circle_fill, color: Color(0xFF34C759), size: 18)
                    else
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF007AFF)),
                        ),
                      ),
                  ],
                ),
              ),
            )),

        const SizedBox(height: 24),

        // Action button (GlassButton uses onTap)
        Center(
          child: GlassButton(
            onTap: () {
              if (isDone || isCancelled) {
                appState.transferService.closeSession();
                Navigator.of(context).pop();
              } else {
                appState.transferService.cancelActiveTransfer();
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              child: Text(
                isDone ? 'Done' : (isCancelled ? 'Dismiss' : 'Cancel Transfer'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDone ? const Color(0xFF34C759) : (isCancelled ? Colors.white70 : const Color(0xFFFF453A)),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
