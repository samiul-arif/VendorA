import '../../../../core/utils/result.dart';
import '../repositories/auth_repository_interface.dart';

// Logout Use Case
class LogoutUseCase {
  final IAuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<Result<void>> execute() async {
    return await _repository.logout();
  }
}
