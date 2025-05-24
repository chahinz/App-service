// import 'package:flutter/material.dart';

// class BookingsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("My Bookings"),
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: "Upcoming"),
//               Tab(text: "Completed"),
//               Tab(text: "Canceled"),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: List.generate(3, (tabIndex) {
//             return ListView.builder(
//               itemCount: 5,
//               itemBuilder: (_, index) => ListTile(
//                 leading: CircleAvatar(backgroundColor: Colors.grey[300]),
//                 title: const Text("Service"),
//                 subtitle: const Text("Full name\nDate and time"),
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }


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
    _tabController = TabController(length: 3, vsync: this);
    _bookingsFuture = fetchBookingsForCurrentWorker();
  }

  Future<List<Booking>> fetchBookingsForCurrentWorker() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return [];

    final querySnapshot = await FirebaseFirestore.instance
        .collection('booking')
        .where('customerId', isEqualTo: currentUser.uid)
        .get();

    return querySnapshot.docs
        .map((doc) => Booking.fromDocument(doc.data(), doc.id))
        .toList();
  }

  Future<String> fetchCustomerName(String workerId) async {
    final doc = await FirebaseFirestore.instance.collection('workers').doc(workerId).get();
    if (doc.exists && doc.data()!.containsKey('fullName')) {
      return doc['fullName'];
    }
    return 'Unknown worker';
  }

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
    future: fetchCustomerInfo(booking.workerId),
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

  if (booking.status == 'completed')
  Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Align(
      alignment: Alignment.center,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.star),
        label: const Text('Rate'),
        onPressed: () => _showRatingDialog(booking),
      ),
    ),
  ),
],
          ),
        ),
      );
    },
  );
}

void _showRatingDialog(Booking booking) {
    double selectedRating = 0;
    TextEditingController commentController = TextEditingController();
    bool anonymous = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Rate Your Booking'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < selectedRating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                          onPressed: () {
                            setState(() {
                              selectedRating = index + 1.0;
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                      TextField(
                      controller: commentController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Leave a comment',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: anonymous,
                          onChanged: (value) {
                            setState(() {
                              anonymous = value ?? false;
                            });
                          },
                        ),
                        const Text('Post anonymously'),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                onPressed: () async {
                  if (selectedRating == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a rating before submitting.')),
                    );
                    return;
                  }

                  final currentUser = FirebaseAuth.instance.currentUser;
                  if (currentUser == null) {
                    Navigator.of(context).pop();
                    return;
                  }

                  final reviewerName = anonymous ? 'Anonymous' : currentUser.uid;

                  await FirebaseFirestore.instance
                      .collection('workers')
                      .doc(booking.workerId)
                      .collection('ratings')
                      .add({
                    'rating': selectedRating,
                    'comment': commentController.text.trim(),
                    'reviewerId': reviewerName,
                    'timestamp': FieldValue.serverTimestamp(),
                    'bookingId': booking.id,
                  });

                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Your review has been posted!')),
                  );
                },
                child: const Text('Post Review'),
              ),

              ],
            );
          },
        );
      },
    );
  }

Future<Map<String, String>> fetchCustomerInfo(String workerId) async {
  final doc =
      await FirebaseFirestore.instance.collection('workers').doc(workerId).get();
  if (doc.exists) {
    final data = doc.data()!;
    return {
      'fullName': data['fullName'] ?? 'Unknown Worker',
      'phone': data['phone'] ?? 'No Phone',
    };
  }
  return {'fullName': 'Unknown worker', 'phone': 'No Phone'};
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
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("My Bookings"),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
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