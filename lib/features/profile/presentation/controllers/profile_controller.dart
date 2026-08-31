import '../../../../core/base/base_controller.dart';
import '../../../../core/storage/session_storage.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/models/vendor_model.dart';
import '../../domain/models/operating_hours_model.dart';
import '../../domain/models/bank_account_model.dart';
import '../../domain/models/notification_preferences_model.dart';
import '../../domain/usecases/get_operating_hours_usecase.dart';
import '../../domain/usecases/update_operating_hours_usecase.dart';
import '../../domain/usecases/get_bank_account_usecase.dart';
import '../../domain/usecases/update_bank_account_usecase.dart';
import '../../domain/usecases/update_vendor_profile_usecase.dart';

// Profile, Theme & Shop Settings Controller
class ProfileController extends BaseController {
  final SessionStorage _sessionStorage;
  final GetOperatingHoursUseCase _getOperatingHoursUseCase;
  final UpdateOperatingHoursUseCase _updateOperatingHoursUseCase;
  final GetBankAccountUseCase _getBankAccountUseCase;
  final UpdateBankAccountUseCase _updateBankAccountUseCase;
  final UpdateVendorProfileUseCase _updateVendorProfileUseCase;

  bool _isDarkMode = false;
  List<OperatingHoursModel> _operatingHours = [];
  BankAccountModel? _bankAccount;
  NotificationPreferencesModel _preferences = const NotificationPreferencesModel();

  ProfileController({
    required SessionStorage sessionStorage,
    required GetOperatingHoursUseCase getOperatingHoursUseCase,
    required UpdateOperatingHoursUseCase updateOperatingHoursUseCase,
    required GetBankAccountUseCase getBankAccountUseCase,
    required UpdateBankAccountUseCase updateBankAccountUseCase,
    required UpdateVendorProfileUseCase updateVendorProfileUseCase,
  })  : _sessionStorage = sessionStorage,
        _getOperatingHoursUseCase = getOperatingHoursUseCase,
        _updateOperatingHoursUseCase = updateOperatingHoursUseCase,
        _getBankAccountUseCase = getBankAccountUseCase,
        _updateBankAccountUseCase = updateBankAccountUseCase,
        _updateVendorProfileUseCase = updateVendorProfileUseCase {
    _isDarkMode = _sessionStorage.isDarkMode();
  }

  // Getters
  bool get isDarkMode => _isDarkMode;
  List<OperatingHoursModel> get operatingHours => _operatingHours;
  BankAccountModel? get bankAccount => _bankAccount;
  NotificationPreferencesModel get preferences => _preferences;

  // Toggle Dark Mode
  Future<void> toggleDarkMode(bool enabled) async {
    _isDarkMode = enabled;
    await _sessionStorage.setDarkMode(enabled);
    notifyListeners();
  }

  // Load Settings & Operating Hours
  Future<void> loadProfileSettings({String shopId = 'shop_01', String vendorId = 'vendor_001'}) async {
    await runWithState<void>(() async {
      final hoursResult = await _getOperatingHoursUseCase.execute(shopId: shopId);
      if (hoursResult is Success<List<OperatingHoursModel>>) {
        _operatingHours = hoursResult.data;
      }

      final bankResult = await _getBankAccountUseCase.execute(vendorId: vendorId);
      if (bankResult is Success<BankAccountModel>) {
        _bankAccount = bankResult.data;
      }

      return const Success<void>(null);
    });
  }

  // Update Operating Hours for a Day
  Future<Result<List<OperatingHoursModel>>> updateDayHours({
    required String shopId,
    required int index,
    required OperatingHoursModel updatedDay,
  }) async {
    final updatedList = List<OperatingHoursModel>.from(_operatingHours);
    if (index >= 0 && index < updatedList.length) {
      updatedList[index] = updatedDay;
      final result = await _updateOperatingHoursUseCase.execute(
        shopId: shopId,
        hours: updatedList,
      );

      if (result is Success<List<OperatingHoursModel>>) {
        _operatingHours = result.data;
        notifyListeners();
      }
      return result;
    }
    return Success(_operatingHours);
  }

  // Update Bank Account Details
  Future<Result<BankAccountModel>> updateBankDetails({
    required String vendorId,
    required String bankName,
    required String accountNumber,
    required String accountHolderName,
    required String routingNumber,
  }) async {
    final account = BankAccountModel(
      bankName: bankName,
      accountNumber: accountNumber,
      accountHolderName: accountHolderName,
      routingNumber: routingNumber,
    );

    final result = await _updateBankAccountUseCase.execute(
      vendorId: vendorId,
      account: account,
    );

    if (result is Success<BankAccountModel>) {
      _bankAccount = result.data;
      notifyListeners();
    }
    return result;
  }

  // Update Preferences
  void updateNotificationPreferences(NotificationPreferencesModel prefs) {
    _preferences = prefs;
    notifyListeners();
  }

  // Update Profile
  Future<Result<VendorModel>> updateProfile({
    required String vendorId,
    required String name,
    required String businessName,
    required String phone,
  }) async {
    return await _updateVendorProfileUseCase.execute(
      vendorId: vendorId,
      name: name,
      businessName: businessName,
      phone: phone,
    );
  }
}
