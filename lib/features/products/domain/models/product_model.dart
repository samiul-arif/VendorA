// Product & Inventory Model
class ProductModel {
  final String id;
  final String shopId;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final int stockQuantity;
  final int lowStockThreshold;
  final bool isAvailable;
  final bool isManualOutOfStock;
  final String categoryId;
  final String categoryName;
  final String imageUrl;
  final int preparationTimeMinutes;
  final bool isPopular;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductModel({
    required this.id,
    required this.shopId,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.stockQuantity,
    this.lowStockThreshold = 3,
    this.isAvailable = true,
    this.isManualOutOfStock = false,
    required this.categoryId,
    required this.categoryName,
    required this.imageUrl,
    this.preparationTimeMinutes = 15,
    this.isPopular = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // Effective availability accounting for stock count and manual offline kitchen pause
  bool get isEffectiveAvailable =>
      isAvailable && !isManualOutOfStock && stockQuantity > 0;

  // Auto Stock Status Check
  bool get isOutOfStock => stockQuantity <= 0 || isManualOutOfStock;

  // Low Stock Alert Check (Amber Warning)
  bool get isLowStock => stockQuantity > 0 && stockQuantity <= lowStockThreshold;

  ProductModel copyWith({
    String? id,
    String? shopId,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    int? stockQuantity,
    int? lowStockThreshold,
    bool? isAvailable,
    bool? isManualOutOfStock,
    String? categoryId,
    String? categoryName,
    String? imageUrl,
    int? preparationTimeMinutes,
    bool? isPopular,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      isAvailable: isAvailable ?? this.isAvailable,
      isManualOutOfStock: isManualOutOfStock ?? this.isManualOutOfStock,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      imageUrl: imageUrl ?? this.imageUrl,
      preparationTimeMinutes:
          preparationTimeMinutes ?? this.preparationTimeMinutes,
      isPopular: isPopular ?? this.isPopular,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shopId': shopId,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'stockQuantity': stockQuantity,
      'lowStockThreshold': lowStockThreshold,
      'isAvailable': isAvailable,
      'isManualOutOfStock': isManualOutOfStock,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'imageUrl': imageUrl,
      'preparationTimeMinutes': preparationTimeMinutes,
      'isPopular': isPopular,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      shopId: json['shopId'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      stockQuantity: json['stockQuantity'] as int? ?? 0,
      lowStockThreshold: json['lowStockThreshold'] as int? ?? 3,
      isAvailable: json['isAvailable'] as bool? ?? true,
      isManualOutOfStock: json['isManualOutOfStock'] as bool? ?? false,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
      preparationTimeMinutes: json['preparationTimeMinutes'] as int? ?? 15,
      isPopular: json['isPopular'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }
}
