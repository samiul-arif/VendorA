// Analytics Time Range Filter Enum

enum AnalyticsTimeRange {
  today('Today', 'vs yesterday'),
  week('Week', 'vs previous 7 days'),
  month('Month', 'vs previous 30 days'),
  custom('Custom', 'vs previous period');

  final String label;
  final String comparisonLabel;

  const AnalyticsTimeRange(this.label, this.comparisonLabel);
}
