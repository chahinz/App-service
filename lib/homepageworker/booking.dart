

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:servili/models/bookingmodel.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  _BookingsScreenState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Booking>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _bookingsFuture = fetchBookingsForCurrentWorker();
  }

  Future<List<Booking>> fetchBookingsForCurrentWorker() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return [];

    final querySnapshot = await FirebaseFirestore.instance
        .collection('booking')
        .where('workerId', isEqualTo: currentUser.uid)
        .get();

    return querySnapshot.docs
        .map((doc) => Booking.fromDocument(doc.data(), doc.id))
        .toList();
  }

  // Future<String> fetchCustomerName(String customerId) async {
  //   final doc = await FirebaseFirestore.instance.collection('customers').doc(customerId).get();
  //   if (doc.exists && doc.data()!.containsKey('fullName')) {
  //     return doc['fullName'];
  //   }
  //   return 'Unknown Customer';
  // }

  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
  await FirebaseFirestore.instance
      .collection('booking')
      .doc(bookingId)
      .update({'status': newStatus});
  setState(() {
    _bookingsFuture = fetchBookingsForCurrentWorker();
  });
}


  Widget _buildBookingTile(Booking booking) {
  return FutureBuilder<Map<String, String>>(
    future: fetchCustomerInfo(booking.customerId),
    builder: (context, snapshot) {
      final customerName = snapshot.data?['fullName'] ?? "Loading...";
      final customerPhone = snapshot.data?['phone'] ?? "";

      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: ExpansionTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: const Color.fromARGB(255, 5, 69, 196),
            child: Icon(Icons.person, color: Colors.white, size: 24),
          ),
          title: Text("$customerName"),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
  Row(
    children: [
      const Icon(Icons.location_on, size: 18, color: Colors.grey),
      const SizedBox(width: 6),
      Expanded(child: Text(booking.location)),
    ],
  ),
  const SizedBox(height: 6),
  Row(
    children: [
      const Text("🗓️", style: TextStyle(fontSize: 18)),
      const SizedBox(width: 6),
      Expanded(child: Text("Date: ${booking.bookingDateTime.toLocal()}")),
    ],
  ),
  const SizedBox(height: 6),
  Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
       const Icon(Icons.info, size: 18, color: Colors.grey),
      const SizedBox(width: 6),
      Expanded(child: Text("Description: ${booking.note}")),
    ],
  ),
  const SizedBox(height: 6),
  Row(
    children: [
      const SizedBox(width: 6),
      Expanded(child: Text(" 📞 Phone: $customerPhone")),
    ],
  ),
],
          ),
          children: [
            if (booking.status == 'pending')
  ButtonBar(
    alignment: MainAxisAlignment.spaceEvenly,
    children: [
      ElevatedButton(
        onPressed: () async {
          await updateBookingStatus(booking.id, 'accepted');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 14, 138, 18),
          foregroundColor: Colors.white,
        ),
        child: const Text("Accept"),
      ),
      ElevatedButton(
        onPressed: () async {
          await updateBookingStatus(booking.id, 'rejected');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        child: const Text("Reject"),
      ),
    ],
  )
  else if (booking.status == 'accepted') ...[
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
    child: ElevatedButton(
      onPressed: () async {
        await updateBookingStatus(booking.id, 'completed');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      child: const Text("Done"),
    ),
  )
  ],
          ],
        ),
      );
    },
  );
}

Future<Map<String, String>> fetchCustomerInfo(String customerId) async {
  final doc =
      await FirebaseFirestore.instance.collection('customers').doc(customerId).get();
  if (doc.exists) {
    final data = doc.data()!;
    return {
      'fullName': data['fullName'] ?? 'Unknown Customer',
      'phone': data['phone'] ?? 'No Phone',
    };
  }
  return {'fullName': 'Unknown Customer', 'phone': 'No Phone'};
}


 Widget _buildBookingList(List<Booking> bookingsForTab) {
    if (bookingsForTab.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "No bookings under this part yet.",
            style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
      );
    }

    return ListView(
      children: bookingsForTab.map(_buildBookingTile).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("My Bookings"),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Requested"),
              Tab(text: "Upcoming"),
              Tab(text: "Completed"),
              Tab(text: "Canceled"),
            ],
          ),
        ),
        body: FutureBuilder<List<Booking>>(
          future: _bookingsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No bookings found.'));
            }

            final bookings = snapshot.data!;

            return TabBarView(
              controller: _tabController,
              children: [
                _buildBookingList(bookings.where((b) => b.status == 'pending').toList()),
                _buildBookingList(bookings.where((b) => b.status == 'accepted').toList()),
                _buildBookingList(bookings.where((b) => b.status == 'completed').toList()),
                _buildBookingList(bookings
                    .where((b) => b.status == 'canceled' || b.status == 'rejected')
                    .toList()),
              ],
            );
          },
        ),
      ),
    );
  }
}



//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 4,
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           title: const Text("My Bookings"),
//           bottom: TabBar(
//             controller: _tabController,
//             tabs: const [
//               Tab(text: "Requested"),
//               Tab(text: "Upcoming"),
//               Tab(text: "Completed"),
//               Tab(text: "Canceled"),
//             ],
//           ),
//         ),
//         body: FutureBuilder<List<Booking>>(
//           future: _bookingsFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return const Center(child: Text('No bookings found.'));
//             }

//             final bookings = snapshot.data!;

//             return TabBarView(
//               controller: _tabController,
//               children: [
//                 ListView(
//                   children: bookings
//                       .where((b) => b.status == 'pending')
//                       .map(_buildBookingTile)
//                       .toList(),
                      
//                 ),

//                 ListView(
//                   children: bookings
//                       .where((b) => b.status == 'accepted') 
//                       .map(_buildBookingTile)
//                       .toList(),
//                 ),

//                 ListView(
//                   children: bookings
//                       .where((b) => b.status == 'completed')
//                       .map(_buildBookingTile)
//                       .toList(),
//                 ),

//                 ListView(
//                   children: bookings
//                       .where((b) => b.status == 'canceled' || b.status == 'rejected')
//                       .map(_buildBookingTile)
//                       .toList(),
//                 ),

//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

