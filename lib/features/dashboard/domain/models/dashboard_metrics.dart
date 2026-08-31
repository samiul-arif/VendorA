// Dashboard Metrics Summary Model
class DashboardMetrics {
  final double totalEarningsToday;
  final double earningsGrowthPercentage;
  final int totalOrdersToday;
  final int activeOrdersCount;
  final double averageTicketSize;
  final double weeklyEarnings;
  final double nextPayoutAmount;
  final double storeRating;
  final int totalReviews;
  final DateTime lastUpdated;

  const DashboardMetrics({
    required this.totalEarningsToday,
    required this.earningsGrowthPercentage,
    required this.totalOrdersToday,
    required this.activeOrdersCount,
    required this.averageTicketSize,
    required this.weeklyEarnings,
    required this.nextPayoutAmount,
    required this.storeRating,
    required this.totalReviews,
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
    double? storeRating,
    int? totalReviews,
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
      storeRating: storeRating ?? this.storeRating,
      totalReviews: totalReviews ?? this.totalReviews,
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
      'storeRating': storeRating,
      'totalReviews': totalReviews,
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
      storeRating: (json['storeRating'] as num?)?.toDouble() ?? 4.8,
      totalReviews: json['totalReviews'] as int? ?? 0,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : DateTime.now(),
    );
  }
}
