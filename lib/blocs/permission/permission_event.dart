part of 'permission_bloc.dart';

abstract class PermissionEvent extends Equatable {
  const PermissionEvent();

  @override
  List<Object> get props => [];
}

class GpsAndPermissionEvent extends PermissionEvent {
  final bool isGpsEnabled;
  final bool isGpsPermissionGranted;
  final bool isPhonePermissionGranted;
  final bool isCameraPermissionGranted;
  final bool isBackgroundLocationEnabled;

  const GpsAndPermissionEvent({
    required this.isGpsEnabled,
    required this.isGpsPermissionGranted,
    required this.isPhonePermissionGranted,
    required this.isCameraPermissionGranted,
    required this.isBackgroundLocationEnabled,
  });
}

class OnChangeNotificationGranted extends PermissionEvent {
  final bool isNotificationPermissionGranted;

  const OnChangeNotificationGranted({
    required this.isNotificationPermissionGranted,
  });
}

class OnAddPhoneEvent extends PermissionEvent {
  final bool isSetPhone;

  const OnAddPhoneEvent({
    required this.isSetPhone,
  });
}

class OnChangeDestinationPageEvent extends PermissionEvent {
  final Widget destinationPage;

  const OnChangeDestinationPageEvent({
    required this.destinationPage,
  });
}
