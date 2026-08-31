import '../../../../core/base/base_controller.dart';
import '../../../../core/utils/result.dart';
import '../../domain/models/app_permission_type.dart';
import '../../domain/models/permission_status_model.dart';
import '../../domain/usecases/check_permission_usecase.dart';
import '../../domain/usecases/request_permission_usecase.dart';

// Permission Controller
class PermissionController extends BaseController {
  final CheckPermissionUseCase _checkPermissionUseCase;
  final RequestPermissionUseCase _requestPermissionUseCase;

  final Map<AppPermissionType, AppPermissionStatus> _permissions = {
    AppPermissionType.camera: AppPermissionStatus.denied,
    AppPermissionType.photos: AppPermissionStatus.denied,
    AppPermissionType.notifications: AppPermissionStatus.granted,
  };

  PermissionController({
    required CheckPermissionUseCase checkPermissionUseCase,
    required RequestPermissionUseCase requestPermissionUseCase,
  })  : _checkPermissionUseCase = checkPermissionUseCase,
        _requestPermissionUseCase = requestPermissionUseCase;

  // Getters
  Map<AppPermissionType, AppPermissionStatus> get permissions => _permissions;

  AppPermissionStatus getStatus(AppPermissionType type) {
    return _permissions[type] ?? AppPermissionStatus.denied;
  }

  bool isGranted(AppPermissionType type) {
    return getStatus(type).isGranted;
  }

  // Check specific permission
  Future<AppPermissionStatus> checkPermission(AppPermissionType type) async {
    final result = await _checkPermissionUseCase.execute(type);
    if (result is Success<AppPermissionStatus>) {
      _permissions[type] = result.data;
      notifyListeners();
      return result.data;
    }
    return _permissions[type] ?? AppPermissionStatus.denied;
  }

  // Request permission
  Future<AppPermissionStatus> requestPermission(AppPermissionType type) async {
    final result = await _requestPermissionUseCase.execute(type);
    if (result is Success<AppPermissionStatus>) {
      _permissions[type] = result.data;
      notifyListeners();
      return result.data;
    }
    return _permissions[type] ?? AppPermissionStatus.denied;
  }

  // Toggle permission directly (for settings management)
  void setPermissionStatus(AppPermissionType type, AppPermissionStatus status) {
    _permissions[type] = status;
    notifyListeners();
  }
}
