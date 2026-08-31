import '../../../../core/utils/result.dart';
import '../models/operating_hours_model.dart';
import '../repositories/profile_repository_interface.dart';

// Update Operating Hours Use Case
class UpdateOperatingHoursUseCase {
  final IProfileRepository _repository;

  UpdateOperatingHoursUseCase(this._repository);

  Future<Result<List<OperatingHoursModel>>> execute({
    required String shopId,
    required List<OperatingHoursModel> hours,
  }) async {
    return await _repository.updateOperatingHours(
      shopId: shopId,
      hours: hours,
    );
  }
}
