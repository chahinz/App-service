import 'package:flutter/material.dart';
import 'package:servili/homepage_client/employeelist.dart';
import 'package:servili/homepage_client/favorite.dart';
import 'package:servili/homepage_client/booking.dart'; 
import 'package:servili/profileclient/editprofile.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

 
  final List<Widget> _screens = [
    const HomeScreenContent(), 
     BookingsScreen(), 
     EditProfileScreen(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _screens[_currentIndex], 
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Booking'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(255, 146, 145, 145),
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


class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(child: _buildCategoryGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF2C3A8C),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Hello,\n Welcome back!",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => FavoritesScreen()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: const Icon(Icons.filter_list),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
   final List<Map<String, String>> services = [
      {'name': 'Plumber', 'image': 'lib/asset/plumber.png'},
      {'name': 'Electrician', 'image': 'lib/asset/electrician.png'},
      {'name': 'Carpenter', 'image': 'lib/asset/carpenter.png'},
      {'name': 'Painter', 'image': 'lib/asset/painter.png'},
      {'name': 'Cleaner', 'image': 'lib/asset/cleaner.png'},
      {'name': 'Gardener', 'image': 'lib/asset/gardner.png'},
      {'name': 'Mechanic', 'image': 'lib/asset/carwasher.png'},
      {'name': 'babysitter', 'image': 'lib/asset/babysitter.png'},
      {'name': 'mason', 'image': 'lib/asset/bricklayer.png'},
      {'name': 'helper', 'image': 'lib/asset/caregiver.png'},
      {'name': 'laundry dooer', 'image': 'lib/asset/laundry.png'},
      {'name': 'nurse', 'image': 'lib/asset/nurse.png'},
      {'name': 'painter', 'image': 'lib/asset/painter.png'},
      {'name': 'pet sitter', 'image': 'lib/asset/petsitter.png'},
      {'name': 'AC Repair', 'image': 'lib/asset/roofer.png'},
      {'name': 'sewer', 'image': 'lib/asset/sewer.png'},
      {'name': 'driver', 'image': 'lib/asset/taxi.png'},
      {'name': 'tiler', 'image': 'lib/asset/tiler.png'},
      {'name': 'window washer', 'image': 'lib/asset/windowash.png'},
      {'name': 'delivery', 'image': 'lib/asset/delivery.png'},
      {'name': 'technician', 'image': 'lib/asset/technician.png'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: services.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 3 / 4,
        ),
        itemBuilder: (context, index) {
          final service = services[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EmployeeListScreen()),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(service['image']!, height: 120, width: 100),
                  const SizedBox(height: 10),
                  Text(
                    service['name']!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
