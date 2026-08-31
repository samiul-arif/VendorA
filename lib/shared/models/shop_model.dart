/// Shop / Merchant Store Entity Model
class ShopModel {
  final String id;
  final String vendorId;
  final String name;
  final String description;
  final String? logoUrl;
  final String? bannerUrl;
  final String address;
  final String city;
  final String phone;
  final bool isOpen;
  final bool autoAcceptOrders;
  final double deliveryFee;
  final double minimumOrderAmount;
  final double rating;
  final int totalReviews;
  final String openingTime; // e.g. "09:00 AM"
  final String closingTime; // e.g. "11:00 PM"
  final String primaryCategory;
  final DateTime createdAt;

  const ShopModel({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.description,
    this.logoUrl,
    this.bannerUrl,
    required this.address,
    required this.city,
    required this.phone,
    required this.isOpen,
    this.autoAcceptOrders = false,
    this.deliveryFee = 2.50,
    this.minimumOrderAmount = 10.0,
    this.rating = 4.8,
    this.totalReviews = 142,
    this.openingTime = '09:00 AM',
    this.closingTime = '11:00 PM',
    this.primaryCategory = 'Restaurant & Cafe',
    required this.createdAt,
  });

  ShopModel copyWith({
    String? id,
    String? vendorId,
    String? name,
    String? description,
    String? logoUrl,
    String? bannerUrl,
    String? address,
    String? city,
    String? phone,
    bool? isOpen,
    bool? autoAcceptOrders,
    double? deliveryFee,
    double? minimumOrderAmount,
    double? rating,
    int? totalReviews,
    String? openingTime,
    String? closingTime,
    String? primaryCategory,
    DateTime? createdAt,
  }) {
    return ShopModel(
      id: id ?? this.id,
      vendorId: vendorId ?? this.vendorId,
      name: name ?? this.name,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      address: address ?? this.address,
      city: city ?? this.city,
      phone: phone ?? this.phone,
      isOpen: isOpen ?? this.isOpen,
      autoAcceptOrders: autoAcceptOrders ?? this.autoAcceptOrders,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      minimumOrderAmount: minimumOrderAmount ?? this.minimumOrderAmount,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
      primaryCategory: primaryCategory ?? this.primaryCategory,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendorId': vendorId,
      'name': name,
      'description': description,
      'logoUrl': logoUrl,
      'bannerUrl': bannerUrl,
      'address': address,
      'city': city,
      'phone': phone,
      'isOpen': isOpen,
      'autoAcceptOrders': autoAcceptOrders,
      'deliveryFee': deliveryFee,
      'minimumOrderAmount': minimumOrderAmount,
      'rating': rating,
      'totalReviews': totalReviews,
      'openingTime': openingTime,
      'closingTime': closingTime,
      'primaryCategory': primaryCategory,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id'] as String,
      vendorId: json['vendorId'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      logoUrl: json['logoUrl'] as String?,
      bannerUrl: json['bannerUrl'] as String?,
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      isOpen: json['isOpen'] as bool? ?? false,
      autoAcceptOrders: json['autoAcceptOrders'] as bool? ?? false,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 2.50,
      minimumOrderAmount: (json['minimumOrderAmount'] as num?)?.toDouble() ?? 10.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      totalReviews: json['totalReviews'] as int? ?? 0,
      openingTime: json['openingTime'] as String? ?? '09:00 AM',
      closingTime: json['closingTime'] as String? ?? '11:00 PM',
      primaryCategory: json['primaryCategory'] as String? ?? 'Restaurant',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
