// import 'package:flutter/material.dart';
// import 'package:servili/homepageworker/ratings.dart';
// import 'booking.dart';
// import 'package:servili/profileclient/editprofile.dart';

// class Homescreenworker extends StatefulWidget {
//   const Homescreenworker({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<Homescreenworker> {
//   int _currentIndex = 0;

//   final List<Widget> _screens = [
//     BookingsScreen(), 
//     RatingsSummaryPage(),
//     EditProfileScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: IndexedStack(
//           index: _currentIndex,
//           children: _screens,
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.book_online), label: 'Bookings'),
//           BottomNavigationBarItem(icon: Icon(Icons.star), label: 'ratings'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//         currentIndex: _currentIndex,
//         selectedItemColor: Colors.white,
//         unselectedItemColor: Color.fromARGB(255, 146, 145, 145),
//         backgroundColor: Color(0xFF3B4A8A),
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:servili/homepageworker/ratings.dart';
import 'booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:servili/homepageworker/editprofil.dart';

class Homescreenworker extends StatefulWidget {
  const Homescreenworker({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Homescreenworker> {
  int _currentIndex = 0;
  bool _isAvailable = false;

  final List<Widget> _screens = [
    BookingsScreen(),
    RatingsSummaryPage(),
    EditProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadAvailabilityStatus();
  }

  Future<void> _loadAvailabilityStatus() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('workers').doc(uid).get();
      if (doc.exists) {
        setState(() {
          _isAvailable = doc.data()?['isAvailable'] ?? false;
        });
      }
    }
  }

  Future<void> _updateAvailabilityInFirestore(bool available) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('workers').doc(uid).update({
        'isAvailable': available,
      });
    }
  }

  void _toggleAvailability() async {
    if (!_isAvailable) {
      bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Activate Availability"),
          content: const Text(
              "When you activate this, you will be available for other people's service requests so they can book you."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Activate"),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        await _updateAvailabilityInFirestore(true);
        setState(() {
          _isAvailable = true;
        });
      }
    } else {
      await _updateAvailabilityInFirestore(false);
      setState(() {
        _isAvailable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleAvailability,
        backgroundColor: _isAvailable ? Colors.green : Colors.red,
        icon: Icon(_isAvailable ? Icons.check_circle : Icons.circle_notifications),
        label: Text(_isAvailable ? "Available" : "Unavailable"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book_online), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Ratings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(255, 146, 145, 145),
        backgroundColor: const Color(0xFF3B4A8A),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
