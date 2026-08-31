// Notification & Sound Preferences
class NotificationPreferencesModel {
  final bool orderAlerts;
  final bool soundEnabled;
  final bool emailReports;
  final bool promotionalAlerts;

  const NotificationPreferencesModel({
    this.orderAlerts = true,
    this.soundEnabled = true,
    this.emailReports = true,
    this.promotionalAlerts = false,
  });

  NotificationPreferencesModel copyWith({
    bool? orderAlerts,
    bool? soundEnabled,
    bool? emailReports,
    bool? promotionalAlerts,
  }) {
    return NotificationPreferencesModel(
      orderAlerts: orderAlerts ?? this.orderAlerts,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      emailReports: emailReports ?? this.emailReports,
      promotionalAlerts: promotionalAlerts ?? this.promotionalAlerts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderAlerts': orderAlerts,
      'soundEnabled': soundEnabled,
      'emailReports': emailReports,
      'promotionalAlerts': promotionalAlerts,
    };
  }

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) {
    return NotificationPreferencesModel(
      orderAlerts: json['orderAlerts'] as bool? ?? true,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      emailReports: json['emailReports'] as bool? ?? true,
      promotionalAlerts: json['promotionalAlerts'] as bool? ?? false,
    );
  }
}
