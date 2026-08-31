// Order Item Entity
class OrderItemModel {
  final String productId;
  final String productName;
  final double unitPrice;
  final int quantity;
  final String? specialInstructions;
  final String? imageUrl;
  final List<String> selectedAddons;

  const OrderItemModel({
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    this.specialInstructions,
    this.imageUrl,
    this.selectedAddons = const [],
  });

  double get totalPrice => unitPrice * quantity;

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'specialInstructions': specialInstructions,
      'imageUrl': imageUrl,
      'selectedAddons': selectedAddons,
      'totalPrice': totalPrice,
    };
  }

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      specialInstructions: json['specialInstructions'] as String?,
      imageUrl: json['imageUrl'] as String?,
      selectedAddons: (json['selectedAddons'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}
