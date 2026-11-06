import 'device.dart';
import 'file_item.dart';

enum TransferDirection {
  send,
  receive,
}

enum TransferSessionStatus {
  waitingForAccept,
  transferring,
  completed,
  failed,
  cancelled,
}

class TransferSession {
  final String id;
  final Device peer;
  final TransferDirection direction;
  final List<FileItem> files;
  final int totalBytes;
  final int transferredBytes;
  final double speedMbps;
  final TransferSessionStatus status;
  final DateTime startTime;
  final String? errorMessage;

  const TransferSession({
    required this.id,
    required this.peer,
    required this.direction,
    required this.files,
    required this.totalBytes,
    this.transferredBytes = 0,
    this.speedMbps = 0.0,
    this.status = TransferSessionStatus.waitingForAccept,
    required this.startTime,
    this.errorMessage,
  });

  TransferSession copyWith({
    String? id,
    Device? peer,
    TransferDirection? direction,
    List<FileItem>? files,
    int? totalBytes,
    int? transferredBytes,
    double? speedMbps,
    TransferSessionStatus? status,
    DateTime? startTime,
    String? errorMessage,
  }) {
    return TransferSession(
      id: id ?? this.id,
      peer: peer ?? this.peer,
      direction: direction ?? this.direction,
      files: files ?? this.files,
      totalBytes: totalBytes ?? this.totalBytes,
      transferredBytes: transferredBytes ?? this.transferredBytes,
      speedMbps: speedMbps ?? this.speedMbps,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  double get overallProgress {
    if (totalBytes <= 0) return 0.0;
    return (transferredBytes / totalBytes).clamp(0.0, 1.0);
  }

  String get formattedSpeed {
    if (speedMbps < 1.0) {
      return '${(speedMbps * 1024).toStringAsFixed(0)} KB/s';
    }
    return '${speedMbps.toStringAsFixed(1)} MB/s';
  }

  String get etaString {
    if (speedMbps <= 0.01) return '--:--';
    final remainingBytes = totalBytes - transferredBytes;
    final remainingSeconds = (remainingBytes / (speedMbps * 1024 * 1024)).ceil();
    if (remainingSeconds < 60) return '${remainingSeconds}s';
    final mins = remainingSeconds ~/ 60;
    final secs = remainingSeconds % 60;
    return '${mins}m ${secs}s';
  }
}
