import 'package:flutter/material.dart';

class BookingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Bookings"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Upcoming"),
              Tab(text: "Completed"),
              Tab(text: "Canceled"),
            ],
          ),
        ),
        body: TabBarView(
          children: List.generate(3, (tabIndex) {
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (_, index) => ListTile(
                leading: CircleAvatar(backgroundColor: Colors.grey[300]),
                title: const Text("Service"),
                subtitle: const Text("Full name\nDate and time"),
              ),
            );
          }),
        ),
      ),
    );
  }
}
