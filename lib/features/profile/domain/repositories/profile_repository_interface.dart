import '../../../../core/utils/result.dart';
import '../../../../shared/models/vendor_model.dart';
import '../models/operating_hours_model.dart';
import '../models/bank_account_model.dart';
import '../models/notification_preferences_model.dart';

// Profile & Store Settings Repository Interface
abstract class IProfileRepository {
  Future<Result<List<OperatingHoursModel>>> getOperatingHours({required String shopId});
  Future<Result<List<OperatingHoursModel>>> updateOperatingHours({
    required String shopId,
    required List<OperatingHoursModel> hours,
  });

  Future<Result<BankAccountModel>> getBankAccount({required String vendorId});
  Future<Result<BankAccountModel>> updateBankAccount({
    required String vendorId,
    required BankAccountModel account,
  });

  Future<Result<NotificationPreferencesModel>> getPreferences();
  Future<Result<NotificationPreferencesModel>> updatePreferences(
    NotificationPreferencesModel preferences,
  );

  Future<Result<VendorModel>> updateVendorProfile({
    required String vendorId,
    required String name,
    required String businessName,
    required String phone,
  });
}
