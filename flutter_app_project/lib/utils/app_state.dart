import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  String? _deviceId;
  String? _sessionId;

  String? get deviceId => _deviceId;
  String? get sessionId => _sessionId;

  Future<void> setDeviceId(String id) async {
    _deviceId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('device_id', id);
    notifyListeners();
  }

  Future<void> setSessionId(String id) async {
    _sessionId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_id', id);
    notifyListeners();
  }

  Future<void> loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _deviceId = prefs.getString('device_id');
    _sessionId = prefs.getString('session_id');
    notifyListeners();
  }
}