import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/device.dart';
import '../models/file_item.dart';
import '../models/transfer_session.dart';

class TransferService extends ChangeNotifier {
  final List<FileItem> _selectedFiles = [];
  final List<FileItem> _transferHistory = [];
  TransferSession? _activeSession;
  Timer? _transferTicker;

  List<FileItem> get selectedFiles => List.unmodifiable(_selectedFiles);
  List<FileItem> get transferHistory => List.unmodifiable(_transferHistory);
  TransferSession? get activeSession => _activeSession;

  TransferService() {
    _populateInitialHistory();
  }

  void _populateInitialHistory() {
    _transferHistory.addAll([
      const FileItem(
        id: 'hist_1',
        name: 'Screen_Recording_20261106.mp4',
        size: 148 * 1024 * 1024,
        type: FileItemType.video,
        status: FileTransferStatus.completed,
        progress: 1.0,
      ),
      const FileItem(
        id: 'hist_2',
        name: 'Architecture_Spec_v3.pdf',
        size: 14 * 1024 * 1024,
        type: FileItemType.pdf,
        status: FileTransferStatus.completed,
        progress: 1.0,
      ),
      const FileItem(
        id: 'hist_3',
        name: 'Flutter_Impeller_Vulkan_Release.apk',
        size: 58 * 1024 * 1024,
        type: FileItemType.apk,
        status: FileTransferStatus.completed,
        progress: 1.0,
      ),
      const FileItem(
        id: 'hist_4',
        name: 'Wallpaper_Gradient_4K.png',
        size: 8 * 1024 * 1024,
        type: FileItemType.image,
        status: FileTransferStatus.completed,
        progress: 1.0,
      ),
    ]);
  }

  void addFiles(List<FileItem> files) {
    _selectedFiles.addAll(files);
    notifyListeners();
  }

  void removeFile(String fileId) {
    _selectedFiles.removeWhere((f) => f.id == fileId);
    notifyListeners();
  }

  void clearSelectedFiles() {
    _selectedFiles.clear();
    notifyListeners();
  }

  void deleteFromHistory(String fileId) {
    _transferHistory.removeWhere((f) => f.id == fileId);
    notifyListeners();
  }

  void startTransfer(Device targetDevice) {
    if (_selectedFiles.isEmpty) return;

    final totalBytes = _selectedFiles.fold<int>(0, (sum, f) => sum + f.size);

    _activeSession = TransferSession(
      id: 'session_${DateTime.now().millisecondsSinceEpoch}',
      peer: targetDevice,
      direction: TransferDirection.send,
      files: List.from(_selectedFiles),
      totalBytes: totalBytes,
      transferredBytes: 0,
      speedMbps: 45.0 + Random().nextDouble() * 15.0,
      status: TransferSessionStatus.transferring,
      startTime: DateTime.now(),
    );
    notifyListeners();

    _transferTicker?.cancel();
    _transferTicker = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (_activeSession == null) {
        timer.cancel();
        return;
      }

      // Transfer increment in chunk
      final chunk = (totalBytes * 0.05).ceil();
      final newTransferred = min(_activeSession!.totalBytes, _activeSession!.transferredBytes + chunk);
      final jitterSpeed = 40.0 + Random().nextDouble() * 20.0;

      if (newTransferred >= _activeSession!.totalBytes) {
        timer.cancel();
        // Add transferred files to history
        for (final file in _activeSession!.files) {
          _transferHistory.insert(0, file.copyWith(status: FileTransferStatus.completed, progress: 1.0));
        }
        _selectedFiles.clear();
        _activeSession = _activeSession!.copyWith(
          transferredBytes: _activeSession!.totalBytes,
          speedMbps: 0.0,
          status: TransferSessionStatus.completed,
        );
      } else {
        _activeSession = _activeSession!.copyWith(
          transferredBytes: newTransferred,
          speedMbps: jitterSpeed,
        );
      }
      notifyListeners();
    });
  }

  void cancelActiveTransfer() {
    _transferTicker?.cancel();
    if (_activeSession != null) {
      _activeSession = _activeSession!.copyWith(
        status: TransferSessionStatus.cancelled,
        speedMbps: 0.0,
      );
      notifyListeners();
    }
  }

  void closeSession() {
    _transferTicker?.cancel();
    _activeSession = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _transferTicker?.cancel();
    super.dispose();
  }
}
