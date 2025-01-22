part of 'permission_bloc.dart';

class PermissionState extends Equatable {
  final bool isGpsEnabled;
  final bool isGpsPermissionGranted;
  final bool isNotificationPermissionGranted;
  final bool isCameraPermissionGranted;
  final bool isPhonePermissionGranted;
  final bool isBackgroundLocationEnabled;

  bool get isAllGranted =>
      isGpsEnabled &&
      isGpsPermissionGranted &&
      isPhonePermissionGranted &&
      isCameraPermissionGranted &&
      isBackgroundLocationEnabled &&
      isNotificationPermissionGranted;

  const PermissionState({
    required this.isGpsEnabled,
    required this.isGpsPermissionGranted,
    required this.isPhonePermissionGranted,
    required this.isCameraPermissionGranted,
    required this.isBackgroundLocationEnabled,
    this.isNotificationPermissionGranted = false,
  });

  PermissionState copyWith({
    bool? isGpsEnabled,
    bool? isGpsPermissionGranted,
    bool? isNotificationPermissionGranted,
    bool? isPhonePermissionGranted,
    bool? isBackgroundLocationEnabled,
    bool? isDataEnabled,
    bool? isSetPhone,
    bool? isCameraPermissionGranted,
    Widget? destinationPage,
  }) =>
      PermissionState(
        isGpsEnabled: isGpsEnabled ?? this.isGpsEnabled,
        isGpsPermissionGranted:
            isGpsPermissionGranted ?? this.isGpsPermissionGranted,
        isNotificationPermissionGranted: isNotificationPermissionGranted ??
            this.isNotificationPermissionGranted,
        isPhonePermissionGranted:
            isPhonePermissionGranted ?? this.isPhonePermissionGranted,
        isCameraPermissionGranted:
            isCameraPermissionGranted ?? this.isCameraPermissionGranted,
        isBackgroundLocationEnabled:
            isBackgroundLocationEnabled ?? this.isBackgroundLocationEnabled,
      );

  @override
  List<Object> get props => [
        isGpsEnabled,
        isGpsPermissionGranted,
        isPhonePermissionGranted,
        isCameraPermissionGranted,
        isBackgroundLocationEnabled,
        isNotificationPermissionGranted,
      ];

  @override
  String toString() {
    return '{ isGpsEnabled: $isGpsEnabled, isGpsPermissionGranted: $isGpsPermissionGranted }';
  }
}
