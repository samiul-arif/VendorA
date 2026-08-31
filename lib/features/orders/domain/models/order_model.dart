import 'order_status.dart';
import 'order_item_model.dart';

// Order Domain Model
class OrderModel {
  final String id;
  final String orderNumber;
  final String shopId;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final String? customerNotes;
  final List<OrderItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double discount;
  final double totalAmount;
  final OrderStatus status;
  final String paymentMethod;
  final bool isPaid;
  final String? riderName;
  final String? riderPhone;
  final String? rejectionReason;
  final int estimatedPrepMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.shopId,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    this.customerNotes,
    required this.items,
    required this.subtotal,
    this.deliveryFee = 2.99,
    this.tax = 0.0,
    this.discount = 0.0,
    required this.totalAmount,
    required this.status,
    this.paymentMethod = 'Online Payment',
    this.isPaid = true,
    this.riderName,
    this.riderPhone,
    this.rejectionReason,
    this.estimatedPrepMinutes = 15,
    required this.createdAt,
    required this.updatedAt,
  });

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  String get itemsSummary => items
      .map((item) => '${item.quantity}x ${item.productName}')
      .join(' • ');

  bool get isPending => status == OrderStatus.pending;
  bool get isAccepted => status == OrderStatus.accepted;
  bool get isPreparing => status == OrderStatus.preparing;
  bool get isReady => status == OrderStatus.ready;
  bool get isDelivered => status == OrderStatus.delivered;
  bool get isCancelled => status == OrderStatus.cancelled;

  OrderModel copyWith({
    String? id,
    String? orderNumber,
    String? shopId,
    String? customerName,
    String? customerPhone,
    String? deliveryAddress,
    String? customerNotes,
    List<OrderItemModel>? items,
    double? subtotal,
    double? deliveryFee,
    double? tax,
    double? discount,
    double? totalAmount,
    OrderStatus? status,
    String? paymentMethod,
    bool? isPaid,
    String? riderName,
    String? riderPhone,
    String? rejectionReason,
    int? estimatedPrepMinutes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      shopId: shopId ?? this.shopId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      customerNotes: customerNotes ?? this.customerNotes,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isPaid: isPaid ?? this.isPaid,
      riderName: riderName ?? this.riderName,
      riderPhone: riderPhone ?? this.riderPhone,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      estimatedPrepMinutes: estimatedPrepMinutes ?? this.estimatedPrepMinutes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'shopId': shopId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'deliveryAddress': deliveryAddress,
      'customerNotes': customerNotes,
      'items': items.map((i) => i.toJson()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'tax': tax,
      'discount': discount,
      'totalAmount': totalAmount,
      'status': status.name,
      'paymentMethod': paymentMethod,
      'isPaid': isPaid,
      'riderName': riderName,
      'riderPhone': riderPhone,
      'rejectionReason': rejectionReason,
      'estimatedPrepMinutes': estimatedPrepMinutes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      orderNumber: json['orderNumber'] as String,
      shopId: json['shopId'] as String,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      deliveryAddress: json['deliveryAddress'] as String,
      customerNotes: json['customerNotes'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 2.99,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: OrderStatus.fromString(json['status'] as String?),
      paymentMethod: json['paymentMethod'] as String? ?? 'Online Payment',
      isPaid: json['isPaid'] as bool? ?? true,
      riderName: json['riderName'] as String?,
      riderPhone: json['riderPhone'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      estimatedPrepMinutes:
          (json['estimatedPrepMinutes'] as num?)?.toInt() ?? 15,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
