// import 'package:flutter/material.dart';
// import 'package:servili/homepage_client/details.dart';

// class EmployeeListScreen extends StatelessWidget {
//   final List<Map<String, dynamic>> employees = List.generate(5, (index) => {
//         'name': 'malek ',
//         'service': 'House cleaning',
//         'location': 'Sidi Bel Abbes',
//         'rating': 5,
//       });

  
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Choose a worker in here")),
//       body: ListView.builder(
//         itemCount: employees.length,
//         itemBuilder: (context, index) {
//           final emp = employees[index];
//           return GestureDetector(
//             onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => EmployeeDetailsPage(),
//               ),
//             );
//           },
//             child: Card(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: ListTile(
//                 leading: CircleAvatar(backgroundColor: Colors.grey[300]),
//                 title: Text(emp['name']),
//                 subtitle: Text(emp['location']),
//                 trailing: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Icon(Icons.favorite_border),
//                     const SizedBox(height: 4),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text('★ ${emp['rating']}'),
//                       ],
                    
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servili/homepage_client/details.dart';

class EmployeeListScreen extends StatelessWidget {
  final String nomservice;

  const EmployeeListScreen({required this.nomservice, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Workers for '$nomservice'")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('workers')
            .where('service', isEqualTo: nomservice)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(child: Text('No workers under this category yet.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final emp = doc.data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmployeeDetailsPage(
                        employeeData: emp,
                      ),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      backgroundImage: emp['imageurl'] != null
                          ? NetworkImage(emp['imageurl'])
                          : null,
                    ),
                    title: Text(emp['fullName'] ?? 'Unnamed'),
                    subtitle: Text(emp['wilaya'] ?? 'No location'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(Icons.favorite_border),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('★ 5'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

