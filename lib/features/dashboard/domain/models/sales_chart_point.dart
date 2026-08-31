// Sales Analytics Chart Data Point Model
class SalesChartPoint {
  final String label;
  final double amount;
  final int orderCount;
  final bool isCurrentDay;

  const SalesChartPoint({
    required this.label,
    required this.amount,
    required this.orderCount,
    this.isCurrentDay = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'amount': amount,
      'orderCount': orderCount,
      'isCurrentDay': isCurrentDay,
    };
  }

  factory SalesChartPoint.fromJson(Map<String, dynamic> json) {
    return SalesChartPoint(
      label: json['label'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      orderCount: json['orderCount'] as int? ?? 0,
      isCurrentDay: json['isCurrentDay'] as bool? ?? false,
    );
  }
}
