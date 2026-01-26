enum APIResultType {
  loading,
  success,
  failure,
  sessionExpired,
  noInternet,
  unauthorised,
  cacheError,
  notFound,
  timeOut,
}

enum NetworkResultType {
  success,
  error,
  cacheError,
  timeOut,
  noInternet,
  unauthorised,
  notFound,
}

enum ImageType { local, network }

enum AppThemesType { light, dark }

enum FontSizeType {
  small(0.9),
  normal(1.0),
  large(1.1);

  final num value;

  const FontSizeType(this.value);
}

enum FontStyleType { manrope }

enum PlatformType {
  android(0),
  ios(1),
  admin(2);

  final int value;

  const PlatformType(this.value);
}

enum SignatureStatus {
  pending, // Not yet uploaded
  success, // Uploaded successfully
  offlinePending, // Failed (no internet)
}

enum OfflineSyncState { idle, syncing, completed }


enum LandscapeSide { left, right, none }


enum DrawerMenu {
  balloonManifest,
  waivers
}

enum CompartmentType {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}



// enum Language {
//   english(Locale('en', 'US'), 'English'),
//   urdu(Locale('ur', 'UR'), 'Urdu');

//   const Language(this.value, this.text);

//   final Locale value;
//   final String text;
// }
