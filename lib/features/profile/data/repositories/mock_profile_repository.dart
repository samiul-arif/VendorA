import '../../../../core/network/base_mock_repository.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/models/vendor_model.dart';
import '../../domain/models/operating_hours_model.dart';
import '../../domain/models/bank_account_model.dart';
import '../../domain/models/notification_preferences_model.dart';
import '../../domain/repositories/profile_repository_interface.dart';

// Mock Profile & Settings Repository
class MockProfileRepository extends BaseMockRepository implements IProfileRepository {
  List<OperatingHoursModel> _operatingHours = const [
    OperatingHoursModel(dayOfWeek: 'Monday', openTime: '08:30 AM', closeTime: '11:00 PM'),
    OperatingHoursModel(dayOfWeek: 'Tuesday', openTime: '08:30 AM', closeTime: '11:00 PM'),
    OperatingHoursModel(dayOfWeek: 'Wednesday', openTime: '08:30 AM', closeTime: '11:00 PM'),
    OperatingHoursModel(dayOfWeek: 'Thursday', openTime: '08:30 AM', closeTime: '11:00 PM'),
    OperatingHoursModel(dayOfWeek: 'Friday', openTime: '08:30 AM', closeTime: '11:30 PM'),
    OperatingHoursModel(dayOfWeek: 'Saturday', openTime: '09:00 AM', closeTime: '11:30 PM'),
    OperatingHoursModel(dayOfWeek: 'Sunday', openTime: '09:00 AM', closeTime: '10:00 PM'),
  ];

  BankAccountModel _bankAccount = const BankAccountModel(
    bankName: 'Chase Bank N.A.',
    accountNumber: '884920194829',
    accountHolderName: 'Arif Food Enterprises LLC',
    routingNumber: '121000358',
    isVerified: true,
    payoutSchedule: 'Weekly (Every Monday)',
  );

  NotificationPreferencesModel _preferences = const NotificationPreferencesModel();

  VendorModel _vendor = VendorModel(
    id: 'vendor_001',
    name: 'Samiul Arif',
    email: 'demo@vendor.com',
    phoneNumber: '+1 (555) 234-5678',
    profileImageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
    businessName: 'Arif Food Enterprises LLC',
    businessRegistrationNumber: 'BN-89234710',
    shopIds: const ['shop_01', 'shop_02', 'shop_03'],
    createdAt: DateTime.now().subtract(const Duration(days: 120)),
  );

  @override
  Future<Result<List<OperatingHoursModel>>> getOperatingHours({required String shopId}) async {
    return executeMock(
      operation: () async => _operatingHours,
      customDelayMs: 200,
    );
  }

  @override
  Future<Result<List<OperatingHoursModel>>> updateOperatingHours({
    required String shopId,
    required List<OperatingHoursModel> hours,
  }) async {
    return executeMock(
      operation: () async {
        _operatingHours = hours;
        return _operatingHours;
      },
      customDelayMs: 300,
    );
  }

  @override
  Future<Result<BankAccountModel>> getBankAccount({required String vendorId}) async {
    return executeMock(
      operation: () async => _bankAccount,
      customDelayMs: 200,
    );
  }

  @override
  Future<Result<BankAccountModel>> updateBankAccount({
    required String vendorId,
    required BankAccountModel account,
  }) async {
    return executeMock(
      operation: () async {
        _bankAccount = account;
        return _bankAccount;
      },
      customDelayMs: 350,
    );
  }

  @override
  Future<Result<NotificationPreferencesModel>> getPreferences() async {
    return executeMock(
      operation: () async => _preferences,
      customDelayMs: 150,
    );
  }

  @override
  Future<Result<NotificationPreferencesModel>> updatePreferences(
    NotificationPreferencesModel preferences,
  ) async {
    return executeMock(
      operation: () async {
        _preferences = preferences;
        return _preferences;
      },
      customDelayMs: 200,
    );
  }

  @override
  Future<Result<VendorModel>> updateVendorProfile({
    required String vendorId,
    required String name,
    required String businessName,
    required String phone,
  }) async {
    return executeMock(
      operation: () async {
        _vendor = _vendor.copyWith(
          name: name,
          businessName: businessName,
          phoneNumber: phone,
        );
        return _vendor;
      },
      customDelayMs: 350,
    );
  }
}
