import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum FileItemType {
  image,
  video,
  pdf,
  document,
  apk,
  audio,
  archive,
  text,
  other,
}

enum FileTransferStatus {
  queued,
  transferring,
  completed,
  failed,
  cancelled,
}

class FileItem {
  final String id;
  final String name;
  final int size; // in bytes
  final String? path;
  final FileItemType type;
  final FileTransferStatus status;
  final double progress; // 0.0 to 1.0

  const FileItem({
    required this.id,
    required this.name,
    required this.size,
    this.path,
    required this.type,
    this.status = FileTransferStatus.queued,
    this.progress = 0.0,
  });

  FileItem copyWith({
    String? id,
    String? name,
    int? size,
    String? path,
    FileItemType? type,
    FileTransferStatus? status,
    double? progress,
  }) {
    return FileItem(
      id: id ?? this.id,
      name: name ?? this.name,
      size: size ?? this.size,
      path: path ?? this.path,
      type: type ?? this.type,
      status: status ?? this.status,
      progress: progress ?? this.progress,
    );
  }

  String get formattedSize {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    if (size < 1024 * 1024 * 1024) return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  IconData get icon {
    switch (type) {
      case FileItemType.image:
        return CupertinoIcons.photo;
      case FileItemType.video:
        return CupertinoIcons.film;
      case FileItemType.pdf:
        return CupertinoIcons.doc_richtext;
      case FileItemType.document:
        return CupertinoIcons.doc_text;
      case FileItemType.apk:
        return CupertinoIcons.app_badge;
      case FileItemType.audio:
        return CupertinoIcons.music_note;
      case FileItemType.archive:
        return CupertinoIcons.archivebox;
      case FileItemType.text:
        return CupertinoIcons.textbox;
      case FileItemType.other:
        return CupertinoIcons.doc;
    }
  }

  Color get badgeColor {
    switch (type) {
      case FileItemType.image:
        return const Color(0xFFFF2D55);
      case FileItemType.video:
        return const Color(0xFFAF52DE);
      case FileItemType.pdf:
        return const Color(0xFFFF3B30);
      case FileItemType.document:
        return const Color(0xFF007AFF);
      case FileItemType.apk:
        return const Color(0xFF34C759);
      case FileItemType.audio:
        return const Color(0xFFFF9500);
      case FileItemType.archive:
        return const Color(0xFF5856D6);
      case FileItemType.text:
        return const Color(0xFF32ADE6);
      case FileItemType.other:
        return const Color(0xFF8E8E93);
    }
  }

  static FileItemType detectType(String filename) {
    final ext = filename.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'heic', 'bmp'].contains(ext)) {
      return FileItemType.image;
    }
    if (['mp4', 'mov', 'mkv', 'avi', 'webm', '3gp'].contains(ext)) {
      return FileItemType.video;
    }
    if (ext == 'pdf') {
      return FileItemType.pdf;
    }
    if (['doc', 'docx', 'txt', 'rtf', 'md', 'epub'].contains(ext)) {
      return FileItemType.document;
    }
    if (ext == 'apk') {
      return FileItemType.apk;
    }
    if (['mp3', 'wav', 'flac', 'aac', 'm4a', 'ogg'].contains(ext)) {
      return FileItemType.audio;
    }
    if (['zip', 'rar', 'tar', 'gz', '7z'].contains(ext)) {
      return FileItemType.archive;
    }
    return FileItemType.other;
  }
}
