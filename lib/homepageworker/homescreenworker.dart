import 'package:flutter/material.dart';
import 'package:servili/homepageworker/ratings.dart';
import 'booking.dart';
import 'package:servili/profileclient/editprofile.dart';

class Homescreenworker extends StatefulWidget {
  const Homescreenworker({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Homescreenworker> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    BookingsScreen(), 
    RatingsSummaryPage(),
    EditProfileScreen(),
  ];

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
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book_online), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'ratings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Color.fromARGB(255, 146, 145, 145),
        backgroundColor: Color(0xFF3B4A8A),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
