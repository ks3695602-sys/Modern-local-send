import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/device.dart';

class DiscoveryService extends ChangeNotifier {
  final List<Device> _devices = [];
  bool _isScanning = false;
  Timer? _scanTimer;

  List<Device> get devices => List.unmodifiable(_devices);
  bool get isScanning => _isScanning;

  DiscoveryService() {
    _populateInitialPeers();
  }

  void _populateInitialPeers() {
    _devices.addAll([
      Device(
        id: 'dev_pixel_9',
        alias: 'Pixel 9 Pro (Living Room)',
        ip: '192.168.1.142',
        deviceType: DeviceType.mobile,
        deviceModel: 'Google Pixel 9 Pro',
        isFavorite: true,
        lastSeen: DateTime.now().subtract(const Duration(seconds: 4)),
        pingMs: 4,
      ),
      Device(
        id: 'dev_mac_studio',
        alias: 'Mac Studio (Workstation)',
        ip: '192.168.1.205',
        deviceType: DeviceType.desktop,
        deviceModel: 'Apple Silicon M2 Max',
        isFavorite: true,
        lastSeen: DateTime.now().subtract(const Duration(seconds: 12)),
        pingMs: 2,
      ),
      Device(
        id: 'dev_ipad_air',
        alias: 'iPad Air 13"',
        ip: '192.168.1.189',
        deviceType: DeviceType.mobile,
        deviceModel: 'Apple iPad Air M2',
        isFavorite: false,
        lastSeen: DateTime.now().subtract(const Duration(seconds: 35)),
        pingMs: 8,
      ),
      Device(
        id: 'dev_windows_rig',
        alias: 'Aurora Windows Rig',
        ip: '192.168.1.110',
        deviceType: DeviceType.desktop,
        deviceModel: 'Windows 11 PC',
        isFavorite: false,
        lastSeen: DateTime.now().subtract(const Duration(minutes: 1)),
        pingMs: 14,
      ),
    ]);
  }

  void startScanning() {
    _isScanning = true;
    notifyListeners();

    _scanTimer?.cancel();
    _scanTimer = Timer(const Duration(seconds: 3), () {
      _isScanning = false;
      notifyListeners();
    });
  }

  void toggleFavorite(String deviceId) {
    final idx = _devices.indexWhere((d) => d.id == deviceId);
    if (idx != -1) {
      final dev = _devices[idx];
      _devices[idx] = dev.copyWith(isFavorite: !dev.isFavorite);
      notifyListeners();
    }
  }

  void addManualDevice(String ip, int port, String alias) {
    final newDevice = Device(
      id: 'manual_${DateTime.now().millisecondsSinceEpoch}',
      alias: alias.isEmpty ? 'Direct Peer ($ip)' : alias,
      ip: ip,
      port: port,
      deviceType: DeviceType.server,
      deviceModel: 'Direct LAN Node',
      lastSeen: DateTime.now(),
      pingMs: 6,
    );
    _devices.insert(0, newDevice);
    notifyListeners();
  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    super.dispose();
  }
}
