import '../../../../core/utils/result.dart';
import '../models/app_permission_type.dart';
import '../models/permission_status_model.dart';
import '../repositories/permission_repository_interface.dart';

// Check Permission Use Case
class CheckPermissionUseCase {
  final IPermissionRepository _repository;

  const CheckPermissionUseCase(this._repository);

  Future<Result<AppPermissionStatus>> execute(AppPermissionType type) {
    return _repository.checkPermission(type);
  }
}
