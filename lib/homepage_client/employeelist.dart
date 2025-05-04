import 'package:flutter/material.dart';

class EmployeeListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> employees = List.generate(5, (index) => {
        'name': 'malek ',
        'service': 'House cleaning',
        'location': 'Sidi Bel Abbes',
        'rating': 5,
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose a worker in here")),
      body: ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final emp = employees[index];
          return GestureDetector(
            onTap: () {
              
            },
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(backgroundColor: Colors.grey[300]),
                title: Text(emp['name']),
                subtitle: Text(emp['location']),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(Icons.favorite_border),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('★ ${emp['rating']}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
