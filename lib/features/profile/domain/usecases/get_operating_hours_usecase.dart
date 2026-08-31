import '../../../../core/utils/result.dart';
import '../models/operating_hours_model.dart';
import '../repositories/profile_repository_interface.dart';

// Get Operating Hours Use Case
class GetOperatingHoursUseCase {
  final IProfileRepository _repository;

  GetOperatingHoursUseCase(this._repository);

  Future<Result<List<OperatingHoursModel>>> execute({
    required String shopId,
  }) async {
    return await _repository.getOperatingHours(shopId: shopId);
  }
}
