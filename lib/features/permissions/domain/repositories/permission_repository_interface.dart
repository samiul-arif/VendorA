import '../../../../core/utils/result.dart';
import '../models/app_permission_type.dart';
import '../models/permission_status_model.dart';

// Permission Repository Interface
abstract class IPermissionRepository {
  Future<Result<AppPermissionStatus>> checkPermission(AppPermissionType type);
  Future<Result<AppPermissionStatus>> requestPermission(AppPermissionType type);
  Future<Result<Map<AppPermissionType, AppPermissionStatus>>> getAllPermissions();
  Future<Result<void>> resetPermissions();
}
