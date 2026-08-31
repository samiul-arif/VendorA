import '../../../../core/utils/result.dart';
import '../../../../shared/models/user_session.dart';
import '../repositories/auth_repository_interface.dart';

// Login Use Case
class LoginUseCase {
  final IAuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Result<UserSession>> execute({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanPassword = password.trim();

    if (cleanEmail.isEmpty) {
      return const Failure('Email address cannot be empty.');
    }
    if (cleanPassword.isEmpty) {
      return const Failure('Password cannot be empty.');
    }

    return await _repository.login(
      email: cleanEmail,
      password: cleanPassword,
    );
  }
}
