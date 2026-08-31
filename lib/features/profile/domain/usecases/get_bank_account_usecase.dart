import '../../../../core/utils/result.dart';
import '../models/bank_account_model.dart';
import '../repositories/profile_repository_interface.dart';

// Get Bank Account Use Case
class GetBankAccountUseCase {
  final IProfileRepository _repository;

  GetBankAccountUseCase(this._repository);

  Future<Result<BankAccountModel>> execute({
    required String vendorId,
  }) async {
    return await _repository.getBankAccount(vendorId: vendorId);
  }
}
