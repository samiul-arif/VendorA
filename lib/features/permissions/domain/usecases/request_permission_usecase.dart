import '../../../../core/utils/result.dart';
import '../models/app_permission_type.dart';
import '../models/permission_status_model.dart';
import '../repositories/permission_repository_interface.dart';

// Request Permission Use Case
class RequestPermissionUseCase {
  final IPermissionRepository _repository;

  const RequestPermissionUseCase(this._repository);

  Future<Result<AppPermissionStatus>> execute(AppPermissionType type) {
    return _repository.requestPermission(type);
  }
}
