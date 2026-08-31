/// Standard UI View State Enum
enum ViewState {
  initial,
  loading,
  success,
  error,
  empty,
  updating,
}

extension ViewStateX on ViewState {
  bool get isInitial => this == ViewState.initial;
  bool get isLoading => this == ViewState.loading;
  bool get isSuccess => this == ViewState.success;
  bool get isError => this == ViewState.error;
  bool get isEmpty => this == ViewState.empty;
  bool get isUpdating => this == ViewState.updating;
  bool get isBusy => this == ViewState.loading || this == ViewState.updating;
}
