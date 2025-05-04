import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  final List<String> favorites = List.generate(5, (index) => 'Full Name');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My fav')),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(favorites[index]),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(backgroundColor: Colors.grey[300]),
                title: Text(favorites[index]),
                subtitle: const Text('Wilaya'),
                trailing: SizedBox(
  width: 60, // Fixed width to ensure layout stability
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: const [
      Icon(Icons.favorite, color: Colors.red, size: 18),
      SizedBox(height: 2),
      Text('★ 5', style: TextStyle(fontSize: 12)),
    ],
  ),
),

              ),
            ),
          );
        },
      ),
    );
  }
}
