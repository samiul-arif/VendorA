// Analytics Summary Entity & Sub-models

import 'analytics_time_range.dart';

class TopPerformerItem {
  final String id;
  final String title;
  final String imageUrl;
  final int ordersCount;
  final double totalRevenue;
  final double growthPercentage;
  final bool isGrowthPositive;

  const TopPerformerItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.ordersCount,
    required this.totalRevenue,
    required this.growthPercentage,
    required this.isGrowthPositive,
  });
}

class RevenueBarPoint {
  final String label;
  final double amount;
  final double targetPercentage; // 0.0 to 1.0 for bar height
  final bool isHighlight;

  const RevenueBarPoint({
    required this.label,
    required this.amount,
    required this.targetPercentage,
    this.isHighlight = false,
  });
}

class AnalyticsSummaryModel {
  final AnalyticsTimeRange range;
  final double grossRevenue;
  final double revenueGrowthPercent;
  final bool isRevenueGrowthPositive;
  final int totalOrders;
  final double ordersGrowthPercent;
  final bool isOrdersGrowthPositive;
  final double avgOrderValue;
  final double aovGrowthPercent;
  final bool isAovGrowthPositive;
  final double pendingPayouts;
  final double settledPayouts;
  final String nextPayoutDate;
  final String bankAccountMasked;
  final List<RevenueBarPoint> chartPoints;
  final List<TopPerformerItem> topPerformers;

  const AnalyticsSummaryModel({
    required this.range,
    required this.grossRevenue,
    required this.revenueGrowthPercent,
    required this.isRevenueGrowthPositive,
    required this.totalOrders,
    required this.ordersGrowthPercent,
    required this.isOrdersGrowthPositive,
    required this.avgOrderValue,
    required this.aovGrowthPercent,
    required this.isAovGrowthPositive,
    required this.pendingPayouts,
    required this.settledPayouts,
    required this.nextPayoutDate,
    required this.bankAccountMasked,
    required this.chartPoints,
    required this.topPerformers,
  });
}
