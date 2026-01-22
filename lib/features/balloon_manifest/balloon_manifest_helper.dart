part of 'balloon_manifest_screen.dart';

class BalloonManifestHelper {
  static final BalloonManifestHelper _singleton =
      BalloonManifestHelper._internal();
  factory BalloonManifestHelper() => _singleton;
  BalloonManifestHelper._internal();

  late BalloonManifestCubit balloonManifestCubit;

  final ValueNotifier<bool> hasCachedTime = ValueNotifier(false);
  final ValueNotifier<String> cacheStatus = ValueNotifier('');
  late ValueNotifier<SignatureStatus> signatureStatus;
  late ValueNotifier<String> signatureTime;
  late NoScreenshot noScreenshot;

  Future<void> initialize() async {
    _initializeDependencies();
    _initializeTimezone();
    _initializeTimeSync();
    initializeScreenPrivacy();
    loadManifestData();
  }

  void _initializeDependencies() {
    balloonManifestCubit = BalloonManifestCubit();
    signatureStatus = ValueNotifier(SignatureStatus.pending);
    signatureTime = ValueNotifier('');
    noScreenshot = NoScreenshot.instance;
  }

  void initializeScreenPrivacy() {
    noScreenshot.screenshotOff();
    noScreenshot.startScreenshotListening();
  }

  void _initializeTimezone() {
    tz.initializeTimeZones();
  }

  void loadManifestData() {
    balloonManifestCubit.callBalloonManifestAPI();
  }

  Future<void> dispose() async {
    balloonManifestCubit.close();
    hasCachedTime.dispose();
    cacheStatus.dispose();
    signatureStatus.dispose();
    signatureTime.dispose();
    noScreenshot.startScreenshotListening();
    await noScreenshot.screenshotOn();
  }

  updateSignedDateInPrefs({required String signedDateTime, String? imageName}) {
    signatureTime.value = Const.convertDateTimeToDMYHM(signedDateTime);
    signatureStatus.value = imageName.isNullOrEmpty()
        ? SignatureStatus.offlinePending
        : SignatureStatus.success;
    final ModelResponseBalloonManifestEntity? cacheData =
        SharedPrefUtils.getBalloonManifest();
    if (cacheData != null && cacheData.assignments.isNotNullAndEmpty) {
      cacheData.assignments!.first.signature =
          ModelResponseBalloonManifestSignature()
            ..date = signedDateTime
            ..imageName = imageName;
    }
    SharedPrefUtils.setBalloonManifest(cacheData.toString());
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
              assignment.signature!.date.isNotNullAndEmpty() &&
              assignment.signature!.imageName.isNotNullAndEmpty()
          ? SignatureStatus.success
          : SharedPrefUtils.getPendingSignatures().isNotNullAndEmpty &&
                SharedPrefUtils.getPendingSignatures()!.any((element) {
                  final data = jsonDecode(element);
                  return data['assignmentId'] == assignment.id;
                })
          ? SignatureStatus.offlinePending
          : SignatureStatus.pending;
      signatureTime.value =
          (assignment.signature != null &&
              assignment.signature!.date.isNotNullAndEmpty())
          ? Const.convertDateTimeToDMYHM(assignment.signature!.date!)
          : '';
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
    ..manifestDate = "2025-11-25"
    ..uniqueId = "MN-001"
    ..assignments = [
      ModelResponseBalloonManifestAssignments()
        ..id = 1
        ..pilotId = "P001"
        ..pilotName = "Rosa Parrera"
        // ..signature = (ModelResponseBalloonManifestSignature()
        //   ..imageName = "pilot_signature.png"
        //   ..imageUrl = "https://example.com/signatures/pilot_signature.png"
        //   ..date = "2025-10-25T13:49:02.443Z")
        ..signature = null
        ..tableNumber = 5
        ..maxWeightWithPax = 1200
        ..defaultWeight = 200
        ..pilotWeight = 75
        ..knownLanguage = [1, 2]
        ..shortCode = "A1"
        ..capacity = 16
        ..paxes = [
          ModelResponseBalloonManifestAssignmentsPaxes()
            ..id = 101
            ..isFOC = false
            ..name = "Alice Johnson"
            ..quadrantPosition = 0
            ..gender = "F"
            ..age = 29
            ..weight = 65
            ..country = "USA"
            ..dietaryRestriction = "Vegan"
            ..specialRequest = "Window side view"
            ..permitNumber = "12345688"
            ..bookingBy = "SafariWorld Tours"
            ..location = "Serengeti North"
            ..driverName = "James Peter"
            ..medicalCondition = "None",
          ModelResponseBalloonManifestAssignmentsPaxes()
            ..id = 102
            ..isFOC = true
            ..name = "Bob Williams"
            ..quadrantPosition = 0
            ..gender = "M"
            ..age = 34
            ..weight = 82
            ..country = "UK"
            ..dietaryRestriction = "None"
            ..specialRequest = "Birthday surprise"
            ..permitNumber = "98887654"
            ..bookingBy = "SafariWorld Tours"
            ..location = "Serengeti North"
            ..driverName = "James Peter"
            ..medicalCondition = "Asthma",
          ModelResponseBalloonManifestAssignmentsPaxes()
            ..id = 103
            ..isFOC = true
            ..name = "Jacob Williams"
            ..quadrantPosition = 1
            ..gender = "M"
            ..age = 34
            ..weight = 82
            ..country = "UK"
            ..dietaryRestriction = "None"
            ..specialRequest = "Birthday surprise"
            ..permitNumber = "98887654"
            ..bookingBy = "SafariWorld Tours"
            ..location = "Serengeti North"
            ..driverName = "James Peter"
            ..medicalCondition = "Asthma",
          ModelResponseBalloonManifestAssignmentsPaxes()
            ..id = 104
            ..isFOC = true
            ..name = "Allow Will"
            ..quadrantPosition = 1
            ..gender = "M"
            ..age = 34
            ..weight = 82
            ..country = "UK"
            ..dietaryRestriction = "None"
            ..specialRequest = "Birthday surprise"
            ..permitNumber = "98887654"
            ..bookingBy = "SafariWorld Tours"
            ..location = "Serengeti North"
            ..driverName = "James Peter"
            ..medicalCondition = "Asthma",
          ModelResponseBalloonManifestAssignmentsPaxes()
            ..id = 105
            ..isFOC = true
            ..name = "Kill Will"
            ..quadrantPosition = 2
            ..gender = "M"
            ..age = 34
            ..weight = 82
            ..country = "UK"
            ..dietaryRestriction = "None"
            ..specialRequest = "Birthday surprise"
            ..permitNumber = "98887654"
            ..bookingBy = "SafariWorld Tours"
            ..location = "Serengeti North"
            ..driverName = "James Peter"
            ..medicalCondition = "Asthma",
          ModelResponseBalloonManifestAssignmentsPaxes()
            ..id = 106
            ..isFOC = true
            ..name = "Young lee"
            ..quadrantPosition = 2
            ..gender = "M"
            ..age = 34
            ..weight = 82
            ..country = "UK"
            ..dietaryRestriction = "None"
            ..specialRequest = "Birthday surprise"
            ..permitNumber = "98887654"
            ..bookingBy = "SafariWorld Tours"
            ..location = "Serengeti North"
            ..driverName = "James Peter"
            ..medicalCondition = "Asthma",
          ModelResponseBalloonManifestAssignmentsPaxes()
            ..id = 107
            ..isFOC = true
            ..name = "Wee lee"
            ..quadrantPosition = 3
            ..gender = "M"
            ..age = 34
            ..weight = 82
            ..country = "UK"
            ..dietaryRestriction = "None"
            ..specialRequest = "Birthday surprise"
            ..permitNumber = "98887654"
            ..bookingBy = "SafariWorld Tours"
            ..location = "Serengeti North"
            ..driverName = "James Peter"
            ..medicalCondition = "Asthma",
          ModelResponseBalloonManifestAssignmentsPaxes()
            ..id = 108
            ..isFOC = false
            ..name = "Alice Johnson"
            ..quadrantPosition = 3
            ..gender = "F"
            ..age = 29
            ..weight = 65
            ..country = "USA"
            ..dietaryRestriction = "Vegan"
            ..specialRequest = "Window side view"
            ..permitNumber = "12345688"
            ..bookingBy = "SafariWorld Tours"
            ..location = "Serengeti North"
            ..driverName = "James Peter"
            ..medicalCondition = "None",
          ModelResponseBalloonManifestAssignmentsPaxes()
            ..id = 109
            ..isFOC = true
            ..name = "Bob Williams"
            ..quadrantPosition = 0
            ..gender = "M"
            ..age = 34
            ..weight = 82
            ..country = "UK"
            ..dietaryRestriction = "None"
            ..specialRequest = "Birthday surprise"
            ..permitNumber = "98887654"
            ..bookingBy = "SafariWorld Tours"
            ..location = "Serengeti North"
            ..driverName = "James Peter"
            ..medicalCondition = "Asthma",
          ModelResponseBalloonManifestAssignmentsPaxes()
            ..id = 110
            ..isFOC = true
            ..name = "Jacob Williams"
            ..quadrantPosition = 0
            ..gender = "M"
            ..age = 34
            ..weight = 82
            ..country = "UK"
            ..dietaryRestriction = "None"
            ..specialRequest = "Birthday surprise"
            ..permitNumber = "98887654"
            ..bookingBy = "SafariWorld Tours"
            ..location = "Serengeti North"
            ..driverName = "James Peter"
            ..medicalCondition = "Asthma",
          ModelResponseBalloonManifestAssignmentsPaxes()
            ..id = 111
            ..isFOC = true
            ..name = "Allow Will"
            ..quadrantPosition = 1
            ..gender = "M"
            ..age = 34
            ..weight = 82
            ..country = "UK"
            ..dietaryRestriction = "None"
            ..specialRequest = "Birthday surprise"
            ..permitNumber = "98887654"
            ..bookingBy = "SafariWorld Tours"
            ..location = "Serengeti North"
            ..driverName = "James Peter"
            ..medicalCondition = "Asthma",
          ModelResponseBalloonManifestAssignmentsPaxes()
            ..id = 112
            ..isFOC = true
            ..name = "Kill Will"
            ..quadrantPosition = 1
            ..gender = "M"
            ..age = 34
            ..weight = 82
            ..country = "UK"
            ..dietaryRestriction = "None"
            ..specialRequest = "Birthday surprise"
            ..permitNumber = "98887654"
            ..bookingBy = "SafariWorld Tours"
            ..location = "Serengeti North"
            ..driverName = "James Peter"
            ..medicalCondition = "Asthma",
          ModelResponseBalloonManifestAssignmentsPaxes()
            ..id = 113
            ..isFOC = true
            ..name = "Young lee"
            ..quadrantPosition = 2
            ..gender = "M"
            ..age = 34
            ..weight = 82
            ..country = "UK"
            ..dietaryRestriction = "None"
            ..specialRequest = "Birthday surprise"
            ..permitNumber = "98887654"
            ..bookingBy = "SafariWorld Tours"
            ..location = "Serengeti North"
            ..driverName = "James Peter"
            ..medicalCondition = "Asthma",
          ModelResponseBalloonManifestAssignmentsPaxes()
            ..id = 114
            ..isFOC = true
            ..name = "Wee lee"
            ..quadrantPosition = 2
            ..gender = "M"
            ..age = 34
            ..weight = 82
            ..country = "UK"
            ..dietaryRestriction = "None"
            ..specialRequest = "Birthday surprise"
            ..permitNumber = "98887654"
            ..bookingBy = "SafariWorld Tours"
            ..location = "Serengeti North"
            ..driverName = "James Peter"
            ..medicalCondition = "Asthma",
        ],
    ];
}
