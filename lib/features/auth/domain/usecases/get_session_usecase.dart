import '../../../../core/utils/result.dart';
import '../../../../shared/models/user_session.dart';
import '../repositories/auth_repository_interface.dart';

// Get Current Session Use Case
class GetSessionUseCase {
  final IAuthRepository _repository;

  GetSessionUseCase(this._repository);

  Future<Result<UserSession?>> execute() async {
    return await _repository.getCurrentSession();
  }
}
