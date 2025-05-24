

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';  
import 'package:flutter/material.dart';

class EmployeeDetailsPage extends StatefulWidget {
  final Map<String, dynamic> employeeData;

  const EmployeeDetailsPage({Key? key, required this.employeeData}) : super(key: key);

  @override
  State<EmployeeDetailsPage> createState() => _EmployeeDetailsPageState();
}

class _EmployeeDetailsPageState extends State<EmployeeDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _noteController = TextEditingController();
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _showBookingDialog() async {
    _noteController.clear();
    _selectedDateTime = null;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Book Now'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: widget.employeeData['imageurl'] != null
                      ? NetworkImage(widget.employeeData['imageurl'])
                      : null,
                  child: widget.employeeData['imageurl'] == null
                      ? const Icon(Icons.person, size: 40)
                      : null,
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    labelText: 'Note',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(_selectedDateTime == null
                      ? 'Pick Date & Time'
                      : '${_selectedDateTime!.toLocal()}'.split('.')[0]),
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (pickedDate != null) {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          _selectedDateTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                        });
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_selectedDateTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select date and time')),
                  );
                  return;
                }
                _saveBooking();
                Navigator.pop(context);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _fetchRatings() async {
  final workerId = widget.employeeData['uid'];

  final ratingsSnapshot = await FirebaseFirestore.instance
      .collection('workers')
      .doc(workerId)
      .collection('ratings')
      .get();

  if (ratingsSnapshot.docs.isEmpty) {
    print("No ratings found in subcollection.");
  }

  return ratingsSnapshot.docs.map((doc) => doc.data()).toList();
}

  Future<void> _saveBooking() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to book.')),
      );
      return;
    }

    final bookingData = {
      'customerId': user.uid,  
      'workerId': widget.employeeData['uid'] ?? 'unknownWorkerId',
      'location': widget.employeeData['wilaya'] ?? 'unknownLocation',
      'note': _noteController.text.trim(),
      'bookingDateTime': _selectedDateTime,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance.collection('booking').add(bookingData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking created successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create booking: $e')),
      );
    }
  }

Future<String> fetchReviewerFullName(String reviewerId) async {
  if (reviewerId == 'Anonymous') return 'Anonymous';

  final doc = await FirebaseFirestore.instance.collection('customers').doc(reviewerId).get();
  if (doc.exists && doc.data()!.containsKey('fullName')) {
    return doc['fullName'];
  }
  return 'Unknown Reviewer';
}

  @override
  Widget build(BuildContext context) {
    final emp = widget.employeeData;

    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 220,
              color: Colors.blue[800],
              child: Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: emp['imageurl'] != null ? NetworkImage(emp['imageurl']) : null,
                  child: emp['imageurl'] == null
                      ? Icon(Icons.person, size: 60, color: Colors.grey[600])
                      : null,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  emp['fullName'] ?? 'Unnamed',
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(Icons.favorite_border, color: Colors.red),
                            ],
                          ),
                          const SizedBox(height: 7),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  emp['service'] ?? 'No Service',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[100],
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.phone, color: Colors.blue, size: 20),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[100],
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.mail_outline, color: Colors.blue, size: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 16, color: Colors.blue),
                              const SizedBox(width: 4),
                              Text(emp['wilaya'] ?? 'No Location'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    TabBar(
                      controller: _tabController,
                      labelColor: Colors.blue[900],
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.blue[900],
                      tabs: const [
                        Tab(text: "About"),
                        Tab(text: "Ratings"),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              emp['description'] ?? "No description available for this employee.",
                              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                            ),
                          ),
      FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchRatings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final ratings = snapshot.data ?? [];

        if (ratings.isEmpty) {
          return const Center(child: Text('No ratings available.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: ratings.length,
          itemBuilder: (context, index) {
            final rating = ratings[index];
                DateTime? ratingDateTime;
          if (rating['timestamp'] != null && rating['timestamp'] is Timestamp) {
            ratingDateTime = (rating['timestamp'] as Timestamp).toDate();
          }
          String formattedDate = ratingDateTime != null
              ? "${ratingDateTime.year}-${ratingDateTime.month.toString().padLeft(2, '0')}-${ratingDateTime.day.toString().padLeft(2, '0')} ${ratingDateTime.hour.toString().padLeft(2, '0')}:${ratingDateTime.minute.toString().padLeft(2, '0')}"
              : "Unknown date";

            // 
            return Container(
  margin: const EdgeInsets.only(bottom: 15),
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: Colors.grey[200],
    borderRadius: BorderRadius.circular(12),
  ),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CircleAvatar(
        backgroundColor: Colors.grey[400],
        child: const Icon(Icons.person, color: Colors.white),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder<String>(
                  future: fetchReviewerFullName(rating['reviewerId'] ?? 'Anonymous'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Loading...', style: TextStyle(fontWeight: FontWeight.bold));
                    } else if (snapshot.hasError) {
                      return const Text('Error', style: TextStyle(fontWeight: FontWeight.bold));
                    } else {
                      return Text(
                        snapshot.data ?? 'Unknown Reviewer',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      );
                    }
                  },
                ),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            Text(rating['comment'] ?? ''),
          ],
        ),
      ),
      const SizedBox(width: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.star, color: Colors.white, size: 16),
            const SizedBox(width: 2),
            Text(
              "${rating['rating'] ?? 0}",
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      )
    ],
  ),
);

          },
        );
      },
    ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: _showBookingDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 1, 44, 107),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("Book Now", style: TextStyle(fontSize: 18 , color: Colors.white) ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}