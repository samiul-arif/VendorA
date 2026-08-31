import '../../../../core/network/base_mock_repository.dart';
import '../../../../core/utils/result.dart';
import '../../domain/models/app_permission_type.dart';
import '../../domain/models/permission_status_model.dart';
import '../../domain/repositories/permission_repository_interface.dart';

// Mock Permission Repository with Realistic OS Permission Simulation
class MockPermissionRepository extends BaseMockRepository implements IPermissionRepository {
  final Map<AppPermissionType, AppPermissionStatus> _permissionStore = {
    AppPermissionType.camera: AppPermissionStatus.denied,
    AppPermissionType.photos: AppPermissionStatus.denied,
    AppPermissionType.notifications: AppPermissionStatus.granted,
  };

  @override
  Future<Result<AppPermissionStatus>> checkPermission(AppPermissionType type) async {
    return executeMock(
      operation: () async => _permissionStore[type] ?? AppPermissionStatus.denied,
      customDelayMs: 80,
    );
  }

  @override
  Future<Result<AppPermissionStatus>> requestPermission(AppPermissionType type) async {
    return executeMock(
      operation: () async {
        // Simulate user allowing the permission
        _permissionStore[type] = AppPermissionStatus.granted;
        return AppPermissionStatus.granted;
      },
      customDelayMs: 250,
    );
  }

  @override
  Future<Result<Map<AppPermissionType, AppPermissionStatus>>> getAllPermissions() async {
    return executeMock(
      operation: () async => Map<AppPermissionType, AppPermissionStatus>.from(_permissionStore),
      customDelayMs: 100,
    );
  }

  @override
  Future<Result<void>> resetPermissions() async {
    return executeMock(
      operation: () async {
        _permissionStore[AppPermissionType.camera] = AppPermissionStatus.denied;
        _permissionStore[AppPermissionType.photos] = AppPermissionStatus.denied;
        _permissionStore[AppPermissionType.notifications] = AppPermissionStatus.denied;
      },
      customDelayMs: 120,
    );
  }
}
