import 'dart:convert';
import '../constants/storage_keys.dart';
import 'storage_service.dart';

/// Session & Credentials Storage Manager
class SessionStorage {
  final IStorageService _storage;

  SessionStorage(this._storage);

  // Authentication State
  Future<void> saveAuthToken(String token) async {
    await _storage.setString(StorageKeys.authToken, token);
  }

  String? getAuthToken() {
    return _storage.getString(StorageKeys.authToken);
  }

  bool get isAuthenticated => getAuthToken() != null && getAuthToken()!.isNotEmpty;

  // Active Shop Management
  Future<void> saveCurrentShopId(String shopId) async {
    await _storage.setString(StorageKeys.currentShop, shopId);
  }

  String? getCurrentShopId() {
    return _storage.getString(StorageKeys.currentShop);
  }

  // Session Data JSON
  Future<void> saveSessionData(Map<String, dynamic> sessionJson) async {
    await _storage.setString(StorageKeys.userSession, jsonEncode(sessionJson));
  }

  Map<String, dynamic>? getSessionData() {
    final raw = _storage.getString(StorageKeys.userSession);
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  // Preferences
  Future<void> setDarkMode(bool isDark) async {
    await _storage.setBool(StorageKeys.isDarkMode, isDark);
  }

  bool isDarkMode() {
    return _storage.getBool(StorageKeys.isDarkMode) ?? false;
  }

  Future<void> setOrderSound(bool enabled) async {
    await _storage.setBool(StorageKeys.orderAlertSoundEnabled, enabled);
  }

  bool isOrderSoundEnabled() {
    return _storage.getBool(StorageKeys.orderAlertSoundEnabled) ?? true;
  }

  // Secure Session Cleanup (Logout Flow)
  Future<void> clearSession() async {
    await _storage.remove(StorageKeys.authToken);
    await _storage.remove(StorageKeys.refreshToken);
    await _storage.remove(StorageKeys.currentVendor);
    await _storage.remove(StorageKeys.currentShop);
    await _storage.remove(StorageKeys.userSession);
  }
}
