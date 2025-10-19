class PushNotificationModel {
  Map<String, dynamic>? data;
  int? notificationID;
  int? notificationType;

  //We are using this boolean to indicate weather update anything or call any API silently in background
  //Or to work in front of user that is via updating UI.
  bool workOnSilentMode = true;
}
