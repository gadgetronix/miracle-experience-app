part of 'balloon_manifest_screen.dart';

class BalloonManifestHelper {
  static final BalloonManifestHelper _singleton =
      BalloonManifestHelper._internal();
  factory BalloonManifestHelper() => _singleton;
  BalloonManifestHelper._internal();

  late final BalloonManifestCubit balloonManifestCubit;
  late final SignOutCubit signOutCubit;

  final ValueNotifier<bool> hasCachedTime = ValueNotifier(false);
  final ValueNotifier<String> cacheStatus = ValueNotifier('');
  late ValueNotifier<SignatureStatus> signatureStatus;
  late ValueNotifier<String> signatureTime;

  Future<void> initialize() async {
    _initializeDependencies();
    _initializeTimezone();
    _initializeTimeSync();
    loadManifestData();
  }

  void _initializeDependencies() {
    balloonManifestCubit = BalloonManifestCubit();
    signOutCubit = SignOutCubit();
    signatureStatus = ValueNotifier(SignatureStatus.pending);
    signatureTime = ValueNotifier('');
  }

  void _initializeTimezone() {
    tz.initializeTimeZones();
  }

  void loadManifestData() {
    balloonManifestCubit.callBalloonManifestAPI();
  }

  // ========== Signout ==========

  void callSignOutAPI() {
    final modelRequestSigninEntity = ModelRequestSigninEntity()
      ..deviceToken = Platform.isAndroid
          ? Const.androidInfo?.id
          : Const.iosInfo?.identifierForVendor
      ..isSignout = true
      ..appVersion = AppInfo.instance.packageInfo?.version ?? ''
      ..osVersion = Platform.isAndroid
          ? Const.androidInfo?.version.release
          : Const.iosInfo?.systemVersion
      ..deviceMf = Platform.isAndroid
          ? Const.androidInfo?.manufacturer
          : Const.iosInfo?.name
      ..deviceModel = Platform.isAndroid
          ? Const.androidInfo?.model
          : Const.iosInfo?.model
      ..uId = Platform.isAndroid
          ? Const.androidInfo?.id
          : Const.iosInfo?.identifierForVendor
      ..userRole = 1
      ..platform = Platform.isAndroid
          ? PlatformType.android.value
          : PlatformType.ios.value;
    signOutCubit.callSignOutAPI(modelRequestSigninEntity);
  }

  // ========== Time Sync ==========

  Future<void> _initializeTimeSync() async {
    await _syncTime();
    await _updateCacheStatus();
  }

  Future<void> onAppResumed() async {
    await _syncTime();
    await _updateCacheStatus();
  }

  Future<void> _syncTime() async {
    try {
      await SecureTimeHelper.syncAndPersist();
    } catch (e) {
      debugPrint('Time sync error: $e');
    }
  }

  Future<void> _updateCacheStatus() async {
    final hasCached = await SecureTimeHelper.hasCachedTime();
    final status = await SecureTimeHelper.getCacheStatus();

    hasCachedTime.value = hasCached;
    cacheStatus.value = status;
  }

  updateSignatureNotifiers({
    ModelResponseBalloonManifestAssignments? assignment,
    ModelResponseBalloonManifestEntity? result,
  }) {
    if (assignment != null) {
      signatureStatus.value =
          assignment.signature != null &&
              assignment.signature!.date.isNotNullAndEmpty()
          ? SignatureStatus.success
          : SharedPrefUtils.getPendingSignatures().isNotNullAndEmpty &&
                SharedPrefUtils.getPendingSignatures()!.any((element) {
                  final data = jsonDecode(element);
                  return data['manifestId'] == result!.uniqueId &&
                      data['assignmentId'] == assignment.id;
                })
          ? SignatureStatus.offlinePending
          : SignatureStatus.pending;
      signatureTime.value = assignment.signature?.date ?? '';
    }
  }

  // ========== Validation ==========

  Future<bool> canShowOfflineData(String manifestDateStr) async {
    try {
      final accurateTime = await SecureTimeHelper.getAccurateTime();

      if (accurateTime == null) {
        debugPrint('Cannot get accurate time for validation');
        return false;
      }

      final eatLocation = tz.getLocation('Africa/Nairobi');
      final eatTime = tz.TZDateTime.from(accurateTime, eatLocation);
      final manifestDate = DateTime.parse(manifestDateStr);
      final cutoffTime = _createCutoffTime(eatLocation, manifestDate);
      final canShow = eatTime.isBefore(cutoffTime);

      _logValidationResult(eatTime, cutoffTime, canShow);
      return canShow;
    } catch (e) {
      debugPrint('Validation error: $e');
      return false;
    }
  }

  tz.TZDateTime _createCutoffTime(tz.Location location, DateTime manifestDate) {
    return tz.TZDateTime(
      location,
      manifestDate.year,
      manifestDate.month,
      manifestDate.day,
      11,
      0,
      0,
    );
  }

  void _logValidationResult(
    tz.TZDateTime currentTime,
    tz.TZDateTime cutoffTime,
    bool canShow,
  ) {
    debugPrint('Current EAT Time: $currentTime');
    debugPrint('Cutoff Time (11 AM): $cutoffTime');
    debugPrint(canShow ? 'Can show offline data' : 'Data expired (past 11 AM)');
  }

  final dummyData = ModelResponseBalloonManifestEntity()
    ..location = "Serengeti North"
    ..manifestDate = "2025-10-25"
    ..uniqueId = "MN-001"
    ..assignments = [
      ModelResponseBalloonManifestAssignments()
        ..id = 1
        ..pilotId = "P001"
        ..pilotName = "John Smith"
        ..signature = (ModelResponseBalloonManifestSignature()
          ..imageName = "pilot_signature.png"
          ..imageUrl = "https://example.com/signatures/pilot_signature.png"
          ..date = "2025-10-25T13:49:02.443Z")
        // ..signature = null
        ..tableNumber = 5
        ..maxWeightWithPax = 1200
        ..defaultWeight = 200
        ..pilotWeight = 75
        ..knownLanguage = [1, 2]
        ..shortCode = "A1"
        ..capacity = 8
        ..paxes = [
          ModelResponseBalloonManifestAssignmentsPaxes()
            ..id = 101
            ..isFOC = false
            ..name = "Alice Johnson"
            ..quadrantPosition = 1
            ..gender = "Female"
            ..age = 29
            ..weight = 65
            ..country = "USA"
            ..dietaryRestriction = "Vegan"
            ..specialRequest = "Window side view"
            ..permitNumber = "PRM12345"
            ..bookingBy = "SafariWorld Tours"
            ..location = "Serengeti North"
            ..driverName = "James Peter"
            ..medicalCondition = "None",
          ModelResponseBalloonManifestAssignmentsPaxes()
            ..id = 102
            ..isFOC = true
            ..name = "Bob Williams"
            ..quadrantPosition = 2
            ..gender = "Male"
            ..age = 34
            ..weight = 82
            ..country = "UK"
            ..dietaryRestriction = "None"
            ..specialRequest = "Birthday surprise"
            ..permitNumber = "PRM54321"
            ..bookingBy = "SafariWorld Tours"
            ..location = "Serengeti North"
            ..driverName = "James Peter"
            ..medicalCondition = "Asthma",
        ],
    ];
}
