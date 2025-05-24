import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String customerId;
  final String workerId;
  final String location;
  final String note;
  final String status;
  final DateTime bookingDateTime;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.customerId,
    required this.workerId,
    required this.location,
    required this.note,
    required this.status,
    required this.bookingDateTime,
    required this.createdAt,
  });

  factory Booking.fromDocument(Map<String, dynamic> data, String documentId) {
    return Booking(
      id: documentId,
      customerId: data['customerId'] ?? '',
      workerId: data['workerId'] ?? '',
      location: data['location'] ?? '',
      note: data['note'] ?? '',
      status: data['status'] ?? '',
      bookingDateTime: (data['bookingDateTime'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
