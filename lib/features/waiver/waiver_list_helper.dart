part of 'wavier_list_screen.dart';



class WaiverListHelper {
  /// Controller for filters
  final TextEditingController bookingCodeController = TextEditingController();

  /// Area dropdown
  final List<String> areaList = ["All locations", "Seronera", "Tarangire", "Lamai", "Kogatende", "Kirawira", "Ndutu", ];
  ValueNotifier<String> selectedArea = ValueNotifier("All locations");

  /// Selected date
  ValueNotifier<DateTime?> selectedDate = ValueNotifier(null);

  /// Waiver list data
  ValueNotifier<List<ModelResponseWaiverListEntity>> waiverList = ValueNotifier([]);

  /// All dummy data (used for filtering)
  final List<ModelResponseWaiverListEntity> _allDummyList = [];

  /// Table Headers
  List<String> get tableHeaders => [
        "Booking Code",
        "Flight Date",
        "Customer Name",
        "Pick up Location",
        "Area",
        "Booking By",
        "Pax",
        "Check In",
        "Action",
      ];

  /// Load Waiver List (dummy for now)
  Future<void> loadWaiverList({bool applyFilter = false}) async {
    if (_allDummyList.isEmpty) {
      _allDummyList.addAll(_getDummyWaiverList());
    }

    if (applyFilter) {
      waiverList.value = _filterList(
        allData: _allDummyList,
        bookingCode: bookingCodeController.text,
        area: selectedArea.value,
        selectedDate: selectedDate.value,
      );
    } else {
      waiverList.value = List.from(_allDummyList);
    }
  }

  /// Dispose all controllers
  void dispose() {
    bookingCodeController.dispose();
  }

  /// Internal: dummy data
  List<ModelResponseWaiverListEntity> _getDummyWaiverList() {
    return [
      ModelResponseWaiverListEntity(
        bookingCode: "ME-1245",
        flightDate: "2025-11-04",
        customerName: "John Doe",
        pickupLocation: "Hotel Pearl Downtown",
        area: "Deira",
        bookingBy: "Ali Hassan",
        pax: 3,
        checkIn: "1/3 Checked in ✅\n2025-11-05 / 10:19 AM",
        isWaiverSigned: true
      ),
      ModelResponseWaiverListEntity(
        bookingCode: "ME-1246",
        flightDate: "2025-11-04",
        customerName: "Sarah Khan",
        pickupLocation: "Hyatt Regency",
        area: "Dubai",
        bookingBy: "Fatima Noor",
        pax: 2,
        checkIn: null,
        isWaiverSigned: false
      ),
      ModelResponseWaiverListEntity(
        bookingCode: "ME-1247",
        flightDate: "2025-11-03",
        customerName: "Omar Ahmed",
        pickupLocation: "Miracle Camp",
        area: "Sharjah",
        bookingBy: "Zaid Raza",
        pax: 4,
        checkIn: "1/3 Checked in ✅\n2025-11-05 / 10:19 AM",
        isWaiverSigned: true
      ),
      ModelResponseWaiverListEntity(
        bookingCode: "ME-1248",
        flightDate: "2025-11-03",
        customerName: "Maria Ali",
        pickupLocation: "Downtown Hotel",
        area: "Dubai",
        bookingBy: "Rehan Khan",
        pax: 1,
        checkIn: null,
        isWaiverSigned: true,
      ),
      ModelResponseWaiverListEntity(
        bookingCode: "ME-1249",
        flightDate: "2025-11-02",
        customerName: "David Smith",
        pickupLocation: "Airport Terminal 3",
        area: "Dubai",
        bookingBy: "Ahmed Raza",
        pax: 5,
        checkIn: null,
        isWaiverSigned: false
      ),
    ];
  }

  /// Internal: filter function
  List<ModelResponseWaiverListEntity> _filterList({
    required List<ModelResponseWaiverListEntity> allData,
    String? bookingCode,
    String? area,
    DateTime? selectedDate,
  }) {
    return allData.where((item) {
      final matchBooking = bookingCode == null ||
          bookingCode.isEmpty ||
          item.bookingCode.orEmpty().toLowerCase().contains(bookingCode.toLowerCase());
      final matchArea = area == null || area == "All" || item.area == area;
      final matchDate = selectedDate == null ||
          item.flightDate ==
              "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

      return matchBooking && matchArea && matchDate;
    }).toList();
  }
}
