import 'dart:convert';
import 'package:flutter/material.dart';
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

  // Theme Preferences (System Default / Light / Dark)
  Future<void> setThemeMode(ThemeMode mode) async {
    String val = 'system';
    if (mode == ThemeMode.light) val = 'light';
    if (mode == ThemeMode.dark) val = 'dark';
    await _storage.setString('app_theme_mode', val);
    await _storage.setBool(StorageKeys.isDarkMode, mode == ThemeMode.dark);
  }

  ThemeMode getThemeMode() {
    final val = _storage.getString('app_theme_mode');
    if (val == 'light') return ThemeMode.light;
    if (val == 'dark') return ThemeMode.dark;
    if (val == 'system') return ThemeMode.system;

    // Fallback legacy boolean check
    final isDarkBool = _storage.getBool(StorageKeys.isDarkMode);
    if (isDarkBool == true) return ThemeMode.dark;
    if (isDarkBool == false) return ThemeMode.light;
    return ThemeMode.system;
  }

  Future<void> setDarkMode(bool isDark) async {
    await setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  bool isDarkMode() {
    return getThemeMode() == ThemeMode.dark;
  }

  Future<void> setOrderSound(bool enabled) async {
    await _storage.setBool(StorageKeys.orderAlertSoundEnabled, enabled);
  }

  bool isOrderSoundEnabled() {
    return _storage.getBool(StorageKeys.orderAlertSoundEnabled) ?? true;
  }

  // Onboarding Status
  Future<void> setOnboardingCompleted(bool completed) async {
    await _storage.setBool(StorageKeys.onboardingCompleted, completed);
  }

  bool isOnboardingCompleted() {
    return _storage.getBool(StorageKeys.onboardingCompleted) ?? false;
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
