import '../../../../core/utils/result.dart';
import '../../../../shared/models/vendor_model.dart';
import '../repositories/profile_repository_interface.dart';

// Update Vendor Profile Info Use Case
class UpdateVendorProfileUseCase {
  final IProfileRepository _repository;

  UpdateVendorProfileUseCase(this._repository);

  Future<Result<VendorModel>> execute({
    required String vendorId,
    required String name,
    required String businessName,
    required String phone,
  }) async {
    if (name.trim().isEmpty) {
      return const Failure('Full name cannot be empty.');
    }
    if (businessName.trim().isEmpty) {
      return const Failure('Business name cannot be empty.');
    }
    return await _repository.updateVendorProfile(
      vendorId: vendorId,
      name: name.trim(),
      businessName: businessName.trim(),
      phone: phone.trim(),
    );
  }
}
