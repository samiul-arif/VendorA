// Device Permission Status Enum
enum AppPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  restricted;

  bool get isGranted => this == AppPermissionStatus.granted;
  bool get isDenied => this == AppPermissionStatus.denied;
  bool get isPermanentlyDenied => this == AppPermissionStatus.permanentlyDenied;

  String get label {
    switch (this) {
      case AppPermissionStatus.granted:
        return 'Allowed';
      case AppPermissionStatus.denied:
        return 'Denied';
      case AppPermissionStatus.permanentlyDenied:
        return 'Disabled in Settings';
      case AppPermissionStatus.restricted:
        return 'Restricted';
    }
  }
}
