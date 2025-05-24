import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
            Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  color: Color(0xFF3B4A8A),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(radius: 45, backgroundColor: Colors.grey[300]),
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.edit, size: 14, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 60),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                CustomTextField(icon: Icons.person, hintText: 'Full name'),
                SizedBox(height: 10),
                CustomTextField(icon: Icons.email, hintText: 'Email'),
                SizedBox(height: 10),
                CustomTextField(icon: Icons.phone, hintText: 'Phone number'),
                SizedBox(height: 10),
                CustomDropdown(icon: Icons.location_city, hintText: 'Wilaya'),
                SizedBox(height: 10),
                CustomDropdown(icon: Icons.apartment, hintText: 'Commune'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3B4A8A),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {},
            child: const Text("update profile",
            style: TextStyle(color: Colors.white, fontSize: 17)
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;

  const CustomTextField({required this.icon, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
              decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Color(0xFF3B4A8A)), 
          hintText: hintText,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3B4A8A), width: 1.5),
          ),
        ),
            );
  }
}

class CustomDropdown extends StatelessWidget {
  final IconData icon;
  final String hintText;

  const CustomDropdown({required this.icon, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      items: ["Option 1", "Option 2"].map((e) {
        return DropdownMenuItem(value: e, child: Text(e));
      }).toList(),
      onChanged: (value) {},
      decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Color(0xFF3B4A8A)), 
          hintText: hintText,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3B4A8A), width: 1.5),
          ),
        ),
    );
  }
}
