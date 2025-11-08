class ModelResponseWaiverListEntity {
  final String? bookingCode;
  final String? flightDate;
  final String? customerName;
  final String? pickupLocation;
  final String? area;
  final String? bookingBy;
  final int? pax;
  final String? checkIn;
  final bool? isWaiverSigned;

  ModelResponseWaiverListEntity({
    required this.bookingCode,
    required this.flightDate,
    required this.customerName,
    required this.pickupLocation,
    required this.area,
    required this.bookingBy,
    required this.pax,
    required this.checkIn,
    required this.isWaiverSigned
  });
}
