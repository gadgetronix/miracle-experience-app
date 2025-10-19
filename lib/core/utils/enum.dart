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

// enum Language {
//   english(Locale('en', 'US'), 'English'),
//   urdu(Locale('ur', 'UR'), 'Urdu');

//   const Language(this.value, this.text);

//   final Locale value;
//   final String text;
// }
