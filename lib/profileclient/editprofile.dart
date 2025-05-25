
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedWilaya;

  final List<String> _wilayas = [
    "01 - Adrar",
    "02 - Chlef",
    "03 - Laghouat",
    "04 - Oum El Bouaghi",
    "05 - Batna",
    "06 - Béjaïa",
    "07 - Biskra",
    "08 - Béchar",
    "09 - Blida",
    "10 - Bouira",
    "11 - Tamanrasset",
    "12 - Tébessa",
    "13 - Tlemcen",
    "14 - Tiaret",
    "15 - Tizi Ouzou",
    "16 - Algiers",
    "17 - Djelfa",
    "18 - Jijel",
    "19 - Sétif",
    "20 - Saïda",
    "21 - Skikda",
    "22 - Sidi Bel Abbès",
    "23 - Annaba",
    "24 - Guelma",
    "25 - Constantine",
    "26 - Médéa",
    "27 - Mostaganem",
    "28 - M'Sila",
    "29 - Mascara",
    "30 - Ouargla",
    "31 - Oran",
    "32 - El Bayadh",
    "33 - Illizi",
    "34 - Bordj Bou Arréridj",
    "35 - Boumerdès",
    "36 - El Tarf",
    "37 - Tindouf",
    "38 - Tissemsilt",
    "39 - El Oued",
    "40 - Khenchela",
    "41 - Souk Ahras",
    "42 - Tipaza",
    "43 - Mila",
    "44 - Aïn Defla",
    "45 - Naâma",
    "46 - Aïn Témouchent",
    "47 - Ghardaïa",
    "48 - Relizane",
    "49 - El M'Ghair",
    "50 - El Menia",
    "51 - Ouled Djellal",
    "52 - Bordj Badji Mokhtar",
    "53 - Béni Abbès",
    "54 - Timimoun",
    "55 - Touggourt",
    "56 - Djanet",
    "57 - In Salah",
    "58 - In Guezzam"
  ];

  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final doc = await FirebaseFirestore.instance.collection('customers').doc(userId).get();
    final data = doc.data();
    if (data != null) {
      setState(() {
        _nameController.text = data['fullName'] ?? '';
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _selectedWilaya = data['wilaya'];
      });
    }
  }

  Future<void> updateProfile() async {
    final dataToUpdate = {
      'fullName': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'wilaya': _selectedWilaya,
      // email not updated here
    };

    final user = FirebaseAuth.instance.currentUser;

    try {
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(user!.uid);
      final workerDocRef = FirebaseFirestore.instance.collection('customers').doc(user.uid);

      await Future.wait([
        userDocRef.update(dataToUpdate),
        workerDocRef.update(dataToUpdate),
      ]);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 
                    MediaQuery.of(context).padding.top - 
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
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
                    CustomTextField(
                      controller: _nameController,
                      icon: Icons.person,
                      hintText: 'Full name',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _emailController,
                      icon: Icons.email,
                      hintText: 'Email',
                      enabled: false, // email is disabled, not editable
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _phoneController,
                      icon: Icons.phone,
                      hintText: 'Phone number',
                    ),
                    const SizedBox(height: 10),
                    CustomDropdown(
                      icon: Icons.location_city,
                      hintText: 'Wilaya',
                      value: _selectedWilaya,
                      items: _wilayas,
                      onChanged: (val) => setState(() => _selectedWilaya = val),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B4A8A),
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: updateProfile,
                      child: const Text(
                        "Update Profile",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hintText;
  final bool enabled;

  const CustomTextField({
    required this.controller,
    required this.icon,
    required this.hintText,
    this.enabled = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF3B4A8A)),
        hintText: hintText,
        filled: true,
        fillColor: enabled ? Colors.grey[200] : Colors.grey[300],
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
  final String? value;
  final List<String> items;
  final void Function(String?) onChanged;

  const CustomDropdown({
    required this.icon,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((e) {
        return DropdownMenuItem(value: e, child: Text(e));
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF3B4A8A)),
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
