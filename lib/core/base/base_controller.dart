import 'package:flutter/foundation.dart';
import '../utils/view_state.dart';
import '../utils/result.dart';

/// Base Controller for Feature State Management
/// Implements standard ViewState transitions and safe notification handling.
abstract class BaseController extends ChangeNotifier {
  ViewState _state = ViewState.initial;
  String? _errorMessage;
  bool _isDisposed = false;

  ViewState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get hasError => _state == ViewState.error && _errorMessage != null;
  bool get isLoading => _state.isLoading;
  bool get isBusy => _state.isBusy;
  bool get isDisposed => _isDisposed;

  /// Sets the view state and notifies listeners safely
  void setState(ViewState newState, {String? error}) {
    if (_isDisposed) return;
    _state = newState;
    _errorMessage = error;
    notifyListeners();
  }

  /// Sets loading state
  void setLoading() => setState(ViewState.loading);

  /// Sets updating state (for in-place mutation like toggling shop status)
  void setUpdating() => setState(ViewState.updating);

  /// Sets success state
  void setSuccess() => setState(ViewState.success);

  /// Sets empty state
  void setEmpty() => setState(ViewState.empty);

  /// Sets error state with a descriptive message
  void setError(String message) => setState(ViewState.error, error: message);

  /// Clears any existing error
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Executes an asynchronous operation handling loading, success, and error states
  Future<Result<T>> runWithState<T>(
    Future<Result<T>> Function() action, {
    bool isUpdate = false,
  }) async {
    if (isUpdate) {
      setUpdating();
    } else {
      setLoading();
    }

    try {
      final result = await action();
      if (_isDisposed) return result;

      if (result is Success<T>) {
        setSuccess();
      } else if (result is Failure<T>) {
        setError(result.message);
      }
      return result;
    } catch (e) {
      if (!_isDisposed) {
        setError(e.toString());
      }
      return Failure(e.toString());
    }
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
