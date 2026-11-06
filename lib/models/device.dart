import 'package:flutter/cupertino.dart';

enum DeviceType {
  mobile,
  desktop,
  browser,
  server,
}

class Device {
  final String id;
  final String alias;
  final String ip;
  final int port;
  final DeviceType deviceType;
  final String deviceModel;
  final bool isFavorite;
  final DateTime lastSeen;
  final int pingMs;

  const Device({
    required this.id,
    required this.alias,
    required this.ip,
    this.port = 53317,
    required this.deviceType,
    required this.deviceModel,
    this.isFavorite = false,
    required this.lastSeen,
    this.pingMs = 12,
  });

  Device copyWith({
    String? id,
    String? alias,
    String? ip,
    int? port,
    DeviceType? deviceType,
    String? deviceModel,
    bool? isFavorite,
    DateTime? lastSeen,
    int? pingMs,
  }) {
    return Device(
      id: id ?? this.id,
      alias: alias ?? this.alias,
      ip: ip ?? this.ip,
      port: port ?? this.port,
      deviceType: deviceType ?? this.deviceType,
      deviceModel: deviceModel ?? this.deviceModel,
      isFavorite: isFavorite ?? this.isFavorite,
      lastSeen: lastSeen ?? this.lastSeen,
      pingMs: pingMs ?? this.pingMs,
    );
  }

  IconData get icon {
    switch (deviceType) {
      case DeviceType.mobile:
        return CupertinoIcons.device_phone_portrait;
      case DeviceType.desktop:
        return CupertinoIcons.device_laptop;
      case DeviceType.browser:
        return CupertinoIcons.globe;
      case DeviceType.server:
        return CupertinoIcons.cube_box;
    }
  }

  Color get accentColor {
    switch (deviceType) {
      case DeviceType.mobile:
        return const Color(0xFF007AFF);
      case DeviceType.desktop:
        return const Color(0xFF5856D6);
      case DeviceType.browser:
        return const Color(0xFFFF9500);
      case DeviceType.server:
        return const Color(0xFF34C759);
    }
  }
}
