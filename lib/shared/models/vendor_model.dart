/// Vendor Entity Model
class VendorModel {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? profileImageUrl;
  final String businessName;
  final String businessRegistrationNumber;
  final List<String> shopIds;
  final DateTime createdAt;

  const VendorModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.profileImageUrl,
    required this.businessName,
    required this.businessRegistrationNumber,
    required this.shopIds,
    required this.createdAt,
  });

  VendorModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
    String? businessName,
    String? businessRegistrationNumber,
    List<String>? shopIds,
    DateTime? createdAt,
  }) {
    return VendorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      businessName: businessName ?? this.businessName,
      businessRegistrationNumber:
          businessRegistrationNumber ?? this.businessRegistrationNumber,
      shopIds: shopIds ?? this.shopIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'businessName': businessName,
      'businessRegistrationNumber': businessRegistrationNumber,
      'shopIds': shopIds,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      businessName: json['businessName'] as String,
      businessRegistrationNumber: json['businessRegistrationNumber'] as String? ?? '',
      shopIds: (json['shopIds'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
