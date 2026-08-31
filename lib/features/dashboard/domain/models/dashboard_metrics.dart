// Dashboard Metrics Summary Model (Vendor Operations & Performance)
class DashboardMetrics {
  final double totalEarningsToday;
  final double earningsGrowthPercentage;
  final int totalOrdersToday;
  final int activeOrdersCount;
  final double averageTicketSize;
  final double weeklyEarnings;
  final double nextPayoutAmount;
  final double fulfillmentRate; // e.g. 98.5%
  final DateTime lastUpdated;

  const DashboardMetrics({
    required this.totalEarningsToday,
    required this.earningsGrowthPercentage,
    required this.totalOrdersToday,
    required this.activeOrdersCount,
    required this.averageTicketSize,
    required this.weeklyEarnings,
    required this.nextPayoutAmount,
    this.fulfillmentRate = 98.5,
    required this.lastUpdated,
  });

  DashboardMetrics copyWith({
    double? totalEarningsToday,
    double? earningsGrowthPercentage,
    int? totalOrdersToday,
    int? activeOrdersCount,
    double? averageTicketSize,
    double? weeklyEarnings,
    double? nextPayoutAmount,
    double? fulfillmentRate,
    DateTime? lastUpdated,
  }) {
    return DashboardMetrics(
      totalEarningsToday: totalEarningsToday ?? this.totalEarningsToday,
      earningsGrowthPercentage:
          earningsGrowthPercentage ?? this.earningsGrowthPercentage,
      totalOrdersToday: totalOrdersToday ?? this.totalOrdersToday,
      activeOrdersCount: activeOrdersCount ?? this.activeOrdersCount,
      averageTicketSize: averageTicketSize ?? this.averageTicketSize,
      weeklyEarnings: weeklyEarnings ?? this.weeklyEarnings,
      nextPayoutAmount: nextPayoutAmount ?? this.nextPayoutAmount,
      fulfillmentRate: fulfillmentRate ?? this.fulfillmentRate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalEarningsToday': totalEarningsToday,
      'earningsGrowthPercentage': earningsGrowthPercentage,
      'totalOrdersToday': totalOrdersToday,
      'activeOrdersCount': activeOrdersCount,
      'averageTicketSize': averageTicketSize,
      'weeklyEarnings': weeklyEarnings,
      'nextPayoutAmount': nextPayoutAmount,
      'fulfillmentRate': fulfillmentRate,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory DashboardMetrics.fromJson(Map<String, dynamic> json) {
    return DashboardMetrics(
      totalEarningsToday: (json['totalEarningsToday'] as num?)?.toDouble() ?? 0.0,
      earningsGrowthPercentage:
          (json['earningsGrowthPercentage'] as num?)?.toDouble() ?? 0.0,
      totalOrdersToday: json['totalOrdersToday'] as int? ?? 0,
      activeOrdersCount: json['activeOrdersCount'] as int? ?? 0,
      averageTicketSize: (json['averageTicketSize'] as num?)?.toDouble() ?? 0.0,
      weeklyEarnings: (json['weeklyEarnings'] as num?)?.toDouble() ?? 0.0,
      nextPayoutAmount: (json['nextPayoutAmount'] as num?)?.toDouble() ?? 0.0,
      fulfillmentRate: (json['fulfillmentRate'] as num?)?.toDouble() ?? 98.5,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : DateTime.now(),
    );
  }
}
