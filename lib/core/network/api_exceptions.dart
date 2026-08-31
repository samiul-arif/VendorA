/// Base Application Exception Hierarchy
sealed class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Network connection failed. Please check your internet.']);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Session expired. Please log in again.'])
      : super(statusCode: 401);
}

class ForbiddenException extends AppException {
  const ForbiddenException([super.message = 'You do not have permission to perform this action.'])
      : super(statusCode: 403);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'The requested resource was not found.'])
      : super(statusCode: 404);
}

class ValidationException extends AppException {
  final Map<String, List<String>>? fieldErrors;
  const ValidationException(super.message, {this.fieldErrors, super.statusCode = 422});
}

class ServerException extends AppException {
  const ServerException([super.message = 'Internal server error occurred. Please try again later.'])
      : super(statusCode: 500);
}
