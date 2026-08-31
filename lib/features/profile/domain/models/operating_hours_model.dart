// Operating Hours Model for Weekly Store Schedule
class OperatingHoursModel {
  final String dayOfWeek;
  final String openTime;
  final String closeTime;
  final bool isClosed;

  const OperatingHoursModel({
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
    this.isClosed = false,
  });

  OperatingHoursModel copyWith({
    String? dayOfWeek,
    String? openTime,
    String? closeTime,
    bool? isClosed,
  }) {
    return OperatingHoursModel(
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      isClosed: isClosed ?? this.isClosed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayOfWeek': dayOfWeek,
      'openTime': openTime,
      'closeTime': closeTime,
      'isClosed': isClosed,
    };
  }

  factory OperatingHoursModel.fromJson(Map<String, dynamic> json) {
    return OperatingHoursModel(
      dayOfWeek: json['dayOfWeek'] as String,
      openTime: json['openTime'] as String? ?? '09:00 AM',
      closeTime: json['closeTime'] as String? ?? '10:00 PM',
      isClosed: json['isClosed'] as bool? ?? false,
    );
  }
}
