import 'vendor_model.dart';
import 'shop_model.dart';

/// User Session Entity
class UserSession {
  final String token;
  final String? refreshToken;
  final VendorModel vendor;
  final ShopModel? activeShop;
  final List<ShopModel> availableShops;
  final DateTime expiresAt;

  const UserSession({
    required this.token,
    this.refreshToken,
    required this.vendor,
    this.activeShop,
    this.availableShops = const [],
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  UserSession copyWith({
    String? token,
    String? refreshToken,
    VendorModel? vendor,
    ShopModel? activeShop,
    List<ShopModel>? availableShops,
    DateTime? expiresAt,
  }) {
    return UserSession(
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      vendor: vendor ?? this.vendor,
      activeShop: activeShop ?? this.activeShop,
      availableShops: availableShops ?? this.availableShops,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'vendor': vendor.toJson(),
      'activeShop': activeShop?.toJson(),
      'availableShops': availableShops.map((s) => s.toJson()).toList(),
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String?,
      vendor: VendorModel.fromJson(json['vendor'] as Map<String, dynamic>),
      activeShop: json['activeShop'] != null
          ? ShopModel.fromJson(json['activeShop'] as Map<String, dynamic>)
          : null,
      availableShops: (json['availableShops'] as List<dynamic>?)
              ?.map((s) => ShopModel.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : DateTime.now().add(const Duration(days: 30)),
    );
  }
}
