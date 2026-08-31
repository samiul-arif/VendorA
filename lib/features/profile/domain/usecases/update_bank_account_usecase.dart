import '../../../../core/utils/result.dart';
import '../models/bank_account_model.dart';
import '../repositories/profile_repository_interface.dart';

// Update Bank Account Use Case
class UpdateBankAccountUseCase {
  final IProfileRepository _repository;

  UpdateBankAccountUseCase(this._repository);

  Future<Result<BankAccountModel>> execute({
    required String vendorId,
    required BankAccountModel account,
  }) async {
    if (account.accountNumber.trim().length < 6) {
      return const Failure('Please enter a valid bank account number.');
    }
    return await _repository.updateBankAccount(
      vendorId: vendorId,
      account: account,
    );
  }
}
