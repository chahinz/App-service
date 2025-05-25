

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:servili/homepage_client/details.dart';

// class EmployeeListScreen extends StatelessWidget {
//   final String nomservice;

//   const EmployeeListScreen({required this.nomservice, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Workers for '$nomservice'")),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('workers')
//             .where('service', isEqualTo: nomservice)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           final docs = snapshot.data?.docs ?? [];

//           if (docs.isEmpty) {
//             return Center(child: Text('No workers under this category yet.'));
//           }

//           return ListView.builder(
//             itemCount: docs.length,
//             itemBuilder: (context, index) {
//               final doc = docs[index];
//               final emp = doc.data() as Map<String, dynamic>;

//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => EmployeeDetailsPage(
//                         employeeData: emp,
//                       ),
//                     ),
//                   );
//                 },
//                 child: Card(
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   child: ListTile(
//                     leading: CircleAvatar(
//                       backgroundColor: Colors.grey[300],
//                       backgroundImage: emp['imageurl'] != null
//                           ? NetworkImage(emp['imageurl'])
//                           : null,
//                     ),
//                     title: Text(emp['fullName'] ?? 'Unnamed'),
//                     subtitle: Text(emp['wilaya'] ?? 'No location'),
//                     trailing: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Icon(Icons.favorite_border),
//                         const SizedBox(height: 4),
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text('★ 5'),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:servili/homepage_client/details.dart';

class EmployeeListScreen extends StatefulWidget {
  final String nomservice;

  const EmployeeListScreen({required this.nomservice, Key? key}) : super(key: key);

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  String? userWilaya;

  @override
  void initState() {
    super.initState();
    fetchUserWilaya();
  }

  Future<void> fetchUserWilaya() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('customers').doc(uid).get();
      if (doc.exists) {
        setState(() {
          userWilaya = doc['wilaya'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Workers for '${widget.nomservice}'")),
      body: userWilaya == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('workers')
                  .where('service', isEqualTo: widget.nomservice)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final docs = snapshot.data?.docs ?? [];

                docs.sort((a, b) {
                  final aData = a.data() as Map<String, dynamic>;
                  final bData = b.data() as Map<String, dynamic>;
                  final aMatch = aData['wilaya'] == userWilaya;
                  final bMatch = bData['wilaya'] == userWilaya;

                  if (aMatch && !bMatch) return -1;
                  if (!aMatch && bMatch) return 1;
                  return 0;
                });

                if (docs.isEmpty) {
                  return const Center(child: Text('No workers found.'));
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
                            builder: (context) => EmployeeDetailsPage(employeeData: emp),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color.fromARGB(255, 3, 55, 98),
                            backgroundImage: emp['imageurl'] != null ? NetworkImage(emp['imageurl']) : null,
                            child: emp['imageurl'] == null
                                ? const Icon(Icons.person, color: Colors.white)
                                : null,
                          ),
                          title: Text(emp['fullName'] ?? 'Unnamed'),
                          subtitle: Text(emp['wilaya'] ?? 'No location'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.circle,
                                size: 14,
                                color: emp['isAvailable'] == true ? Colors.green : Colors.red,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
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


