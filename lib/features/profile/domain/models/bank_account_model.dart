// Merchant Bank Payout Account Details
class BankAccountModel {
  final String bankName;
  final String accountNumber;
  final String accountHolderName;
  final String routingNumber;
  final bool isVerified;
  final String payoutSchedule;

  const BankAccountModel({
    required this.bankName,
    required this.accountNumber,
    required this.accountHolderName,
    required this.routingNumber,
    this.isVerified = true,
    this.payoutSchedule = 'Weekly (Every Monday)',
  });

  String get maskedAccountNumber {
    if (accountNumber.length <= 4) return accountNumber;
    final lastFour = accountNumber.substring(accountNumber.length - 4);
    return '•••• •••• $lastFour';
  }

  BankAccountModel copyWith({
    String? bankName,
    String? accountNumber,
    String? accountHolderName,
    String? routingNumber,
    bool? isVerified,
    String? payoutSchedule,
  }) {
    return BankAccountModel(
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      routingNumber: routingNumber ?? this.routingNumber,
      isVerified: isVerified ?? this.isVerified,
      payoutSchedule: payoutSchedule ?? this.payoutSchedule,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountHolderName': accountHolderName,
      'routingNumber': routingNumber,
      'isVerified': isVerified,
      'payoutSchedule': payoutSchedule,
    };
  }

  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(
      bankName: json['bankName'] as String? ?? 'Chase Bank N.A.',
      accountNumber: json['accountNumber'] as String? ?? '884920194829',
      accountHolderName: json['accountHolderName'] as String? ?? 'Arif Food Enterprises LLC',
      routingNumber: json['routingNumber'] as String? ?? '121000358',
      isVerified: json['isVerified'] as bool? ?? true,
      payoutSchedule: json['payoutSchedule'] as String? ?? 'Weekly (Every Monday)',
    );
  }
}
