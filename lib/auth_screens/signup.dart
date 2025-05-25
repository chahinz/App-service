// import 'package:flutter/material.dart';
// import 'package:servili/homepage_client/homescreen.dart';

// class SignupScreen extends StatelessWidget {
//   const SignupScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: const BackButton(color: Colors.black),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.fromLTRB(
//             32,
//             0,
//             32,
//             MediaQuery.of(context).viewInsets.bottom + 20,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Fill your profile",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 20),
//               Center(
//                 child: CircleAvatar(
//                   radius: 40,
//                   backgroundColor: Colors.grey[200],
//                   child: const Icon(Icons.person_add, size: 40, color: Colors.blue),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               _buildInputField("Full name"),
//               _buildInputField("Phone number"),
//               _buildInputField("Email"),
//               _buildInputField("Password", obscure: true),
//               _buildDropdownField("Wilaya"),
//               _buildDropdownFieldtype("Type"),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => const HomeScreen()),
//                   ); 
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.indigo,
//                   minimumSize: const Size(double.infinity, 48),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                 ),
//                 child: const Text(
//                   "Sign up",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInputField(String hint, {bool obscure = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextField(
//         obscureText: obscure,
//         decoration: InputDecoration(
//           hintText: hint,
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//     );
//   }

//   Widget _buildDropdownField(String label) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: DropdownButtonFormField<String>(
//         items: ["Option 1", "Option 2"]
//             .map((item) => DropdownMenuItem(value: item, child: Text(item)))
//             .toList(),
//         onChanged: (val) {},
//         decoration: InputDecoration(
//           hintText: label,
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//     );
//   }

//   Widget _buildDropdownFieldtype(String label) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: DropdownButtonFormField<String>(
//         items: ["Worker", "Customer"]
//             .map((item) => DropdownMenuItem(value: item, child: Text(item)))
//             .toList(),
//         onChanged: (val) {},
//         decoration: InputDecoration(
//           hintText: label,
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//     );
//   }
// }





// ////this one works

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:servili/homepage_client/homescreen.dart';
// import 'package:servili/homepageworker/homescreenworker.dart';

// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});

//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   String? _selectedWilaya;
//   String? _selectedType;
//   String? _selectedService;

//   final List<String> wilayas = [
//   "Adrar", "Chlef", "Laghouat", "Oum El Bouaghi", "Batna", "Béjaïa", "Biskra",
//   "Béchar", "Blida", "Bouira", "Tamanrasset", "Tébessa", "Tlemcen", "Tiaret",
//   "Tizi Ouzou", "Algiers", "Djelfa", "Jijel", "Sétif", "Saïda", "Skikda", "Sidi Bel Abbès",
//   "Annaba", "Guelma", "Constantine", "Médéa", "Mostaganem", "MSila", "Mascara", "Ouargla",
//   "Oran", "El Bayadh", "Illizi", "Bordj Bou Arreridj", "Boumerdès", "El Tarf", "Tindouf",
//   "Tissemsilt", "El Oued", "Khenchela", "Souk Ahras", "Tipaza", "Mila", "Aïn Defla",
//   "Naâma", "Aïn Témouchent", "Ghardaïa", "Relizane", "El M'Ghair", "El Menia", "Ouled Djellal",
//   "Bordj Badji Mokhtar", "Béni Abbès", "Timimoun", "Touggourt", "Djanet", "In Salah", "In Guezzam"
// ];
//   final List<String> types = ["Worker", "Customer"];

//   final List<String> services = ['Plumber', 'Electrician', 'Painter', 'Mechanic', 'Carpenter' , 'Cleaner' , 'Gardener' , 
//   'Babysitter' , 'mason' , 'helper' , 'Laundry dooer' , 'nurse' , 'pet sitter' , 'AC repair' , 'sewer' , 'driver'
//   , 'tiler' , 'Window washer' , 'Delivery' ,  ];

//   bool _loading = false;

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _phoneController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   // Future<void> _signUp() async {
//   //   if (!_formKey.currentState!.validate()) return;
//   //   if (_selectedWilaya == null || _selectedType == null) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(content: Text('Please select Wilaya and Type')),
//   //     );
//   //     return;
//   //   }

//   //   setState(() => _loading = true);

//   //   try {
//   //     UserCredential userCredential = await FirebaseAuth.instance
//   //         .createUserWithEmailAndPassword(
//   //             email: _emailController.text.trim(),
//   //             password: _passwordController.text);

//   //     String uid = userCredential.user!.uid;

//   //     Map<String, dynamic> userData = {
//   //       'uid': uid,
//   //       'fullName': _nameController.text.trim(),
//   //       'phone': _phoneController.text.trim(),
//   //       'email': _emailController.text.trim(),
//   //       'wilaya': _selectedWilaya,
//   //       'type': _selectedType,
//   //       'createdAt': FieldValue.serverTimestamp(),
//   //     };

//   //     final firestore = FirebaseFirestore.instance;

//   //     await firestore.collection('users').doc(uid).set(userData);

//   //     if (_selectedType == 'Worker') {
//   //       await firestore.collection('workers').doc(uid).set(userData);
//   //     } else {
//   //       await firestore.collection('customers').doc(uid).set(userData);
//   //     }

//   //     if (_selectedType == 'Worker') {
//   //       Navigator.pushReplacement(
//   //           context, MaterialPageRoute(builder: (_) => const Homescreenworker()));
//   //     } else {
//   //       Navigator.pushReplacement(
//   //           context, MaterialPageRoute(builder: (_) => const HomeScreen()));
//   //     }
//   //   } on FirebaseAuthException catch (e) {
//   //     String message = 'An error occurred';
//   //     if (e.code == 'email-already-in-use') {
//   //       message = 'Email is already in use';
//   //     } else if (e.code == 'weak-password') {
//   //       message = 'Password is too weak';
//   //     }
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text(message)),
//   //     );
//   //   } catch (e) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text(e.toString())),
//   //     );
//   //   } finally {
//   //     setState(() => _loading = false);
//   //   }
//   // }

//   Future<void> _signUp() async {
//   if (!_formKey.currentState!.validate()) return;
//   if (_selectedWilaya == null || _selectedType == null) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Please select Wilaya and Type')),
//     );
//     return;
//   }

//   setState(() => _loading = true);

//   try {
//     UserCredential userCredential = await FirebaseAuth.instance
//         .createUserWithEmailAndPassword(
//             email: _emailController.text.trim(),
//             password: _passwordController.text);

//     String uid = userCredential.user!.uid;

//     final firestore = FirebaseFirestore.instance;

//     // Data saved to the general "users" collection, includes "type"
//     Map<String, dynamic> userData = {
//       'uid': uid,
//       'fullName': _nameController.text.trim(),
//       'phone': _phoneController.text.trim(),
//       'email': _emailController.text.trim(),
//       'wilaya': _selectedWilaya,
//       'type': _selectedType,
//       'createdAt': FieldValue.serverTimestamp(),
//     };

//     await firestore.collection('users').doc(uid).set(userData);

//     // Copy data but exclude "type"
//     Map<String, dynamic> profileData = Map.of(userData);
//     profileData.remove('type');

//     if (_selectedType == 'Worker') {
//       await firestore.collection('workers').doc(uid).set(profileData);
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (_) => const Homescreenworker()));
//     } else {
//       await firestore.collection('customers').doc(uid).set(profileData);
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (_) => const HomeScreen()));
//     }
//   } on FirebaseAuthException catch (e) {
//     String message = 'An error occurred';
//     if (e.code == 'email-already-in-use') {
//       message = 'Email is already in use';
//     } else if (e.code == 'weak-password') {
//       message = 'Password is too weak';
//     }
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(e.toString())),
//     );
//   } finally {
//     setState(() => _loading = false);
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: const BackButton(color: Colors.black),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.fromLTRB(
//             32,
//             0,
//             32,
//             MediaQuery.of(context).viewInsets.bottom + 20,
//           ),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Fill your profile",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: CircleAvatar(
//                     radius: 40,
//                     backgroundColor: Colors.grey[200],
//                     child: const Icon(Icons.person_add, size: 40, color: Colors.blue),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 _buildInputField("Full name", controller: _nameController, validator: (val) {
//                   if (val == null || val.isEmpty) return 'Enter your full name';
//                   return null;
//                 }),
//                 _buildInputField("Phone number", controller: _phoneController, keyboardType: TextInputType.phone, validator: (val) {
//                   if (val == null || val.isEmpty) return 'Enter your phone number';
//                   return null;
//                 }),
//                 _buildInputField("Email", controller: _emailController, keyboardType: TextInputType.emailAddress, validator: (val) {
//                   if (val == null || val.isEmpty) return 'Enter your email';
//                   if (!val.contains('@')) return 'Enter a valid email';
//                   return null;
//                 }),
//                 _buildInputField("Password", controller: _passwordController, obscure: true, validator: (val) {
//                   if (val == null || val.length < 6) return 'Password must be at least 6 characters';
//                   return null;
//                 }),
//                 _buildDropdownField("Wilaya", wilayas, _selectedWilaya, (val) {
//                   setState(() => _selectedWilaya = val);
//                 }),
//                 _buildDropdownField("Type", types, _selectedType, (val) {
//                   setState(() => _selectedType = val);
//                 }),
//                 const SizedBox(height: 20),
//                 _loading
//                     ? const Center(child: CircularProgressIndicator())
//                     : ElevatedButton(
//                         onPressed: _signUp,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.indigo,
//                           minimumSize: const Size(double.infinity, 48),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                         ),
//                         child: const Text(
//                           "Sign up",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInputField(String hint,
//       {TextEditingController? controller,
//       bool obscure = false,
//       TextInputType keyboardType = TextInputType.text,
//       String? Function(String?)? validator}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         controller: controller,
//         obscureText: obscure,
//         keyboardType: keyboardType,
//         validator: validator,
//         decoration: InputDecoration(
//           hintText: hint,
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//     );
//   }

//   Widget _buildDropdownField(String label, List<String> items, String? value, Function(String?) onChanged) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: DropdownButtonFormField<String>(
//         value: value,
//         items: items
//             .map((item) => DropdownMenuItem(value: item, child: Text(item)))
//             .toList(),
//         onChanged: onChanged,
//         decoration: InputDecoration(
//           hintText: label,
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//         validator: (val) => val == null ? 'Please select $label' : null,
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:servili/homepage_client/homescreen.dart';
import 'package:servili/homepageworker/homescreenworker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _selectedWilaya;
  String? _selectedType;
  String? _selectedService;

  // final List<String> wilayas = [
  //   "Adrar", "Chlef", "Laghouat", "Oum El Bouaghi", "Batna", "Béjaïa", "Biskra",
  //   "Béchar", "Blida", "Bouira", "Tamanrasset", "Tébessa", "Tlemcen", "Tiaret",
  //   "Tizi Ouzou", "Algiers", "Djelfa", "Jijel", "Sétif", "Saïda", "Skikda", "Sidi Bel Abbès",
  //   "Annaba", "Guelma", "Constantine", "Médéa", "Mostaganem", "MSila", "Mascara", "Ouargla",
  //   "Oran", "El Bayadh", "Illizi", "Bordj Bou Arreridj", "Boumerdès", "El Tarf", "Tindouf",
  //   "Tissemsilt", "El Oued", "Khenchela", "Souk Ahras", "Tipaza", "Mila", "Aïn Defla",
  //   "Naâma", "Aïn Témouchent", "Ghardaïa", "Relizane", "El M'Ghair", "El Menia", "Ouled Djellal",
  //   "Bordj Badji Mokhtar", "Béni Abbès", "Timimoun", "Touggourt", "Djanet", "In Salah", "In Guezzam"
  // ];

  final List<String> wilayas = [
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

  final List<String> types = ["Worker", "Customer"];

  final List<String> services = [
    'Plumber', 'Electrician', 'Painter', 'Mechanic', 'Carpenter', 'Cleaner', 'Gardener',
    'Babysitter', 'Mason', 'Helper', 'Laundry dooer', 'Nurse', 'Pet sitter', 'AC repair',
    'Sewer', 'Driver', 'Tiler', 'Delivery', 'Technician'
  ];

  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedWilaya == null || _selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Wilaya and Type')),
      );
      return;
    }
    if (_selectedType == 'Worker' && _selectedService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a Service')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());

      String uid = userCredential.user!.uid;

      final firestore = FirebaseFirestore.instance;

      Map<String, dynamic> userData = {
        'uid': uid,
        'fullName': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'wilaya': _selectedWilaya,
        'type': _selectedType,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await firestore.collection('users').doc(uid).set(userData);

      Map<String, dynamic> profileData = Map.of(userData);
      profileData.remove('type');

      if (_selectedType == 'Worker') {
        profileData['service'] = _selectedService;
        await firestore.collection('workers').doc(uid).set(profileData);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Homescreenworker()),
        );
      } else {
        await firestore.collection('customers').doc(uid).set(profileData);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Homescreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'email-already-in-use') {
        message = 'Email is already in use';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Widget _buildInputField(String label,
      {required TextEditingController controller,
      TextInputType keyboardType = TextInputType.text,
      bool obscure = false,
      String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items, String? value,
      void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        validator: (val) => val == null ? 'Select $label' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            32,
            0,
            32,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Fill your profile",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    child: const Icon(Icons.person_add, size: 40, color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 20),
                _buildInputField("Full name", controller: _nameController, validator: (val) {
                  if (val == null || val.isEmpty) return 'Enter your full name';
                  return null;
                }),
                _buildInputField("Phone number", controller: _phoneController, keyboardType: TextInputType.phone, validator: (val) {
                  if (val == null || val.isEmpty) return 'Enter your phone number';
                  return null;
                }),
                _buildInputField("Email", controller: _emailController, keyboardType: TextInputType.emailAddress, validator: (val) {
                  if (val == null || val.isEmpty) return 'Enter your email';
                  if (!val.contains('@')) return 'Enter a valid email';
                  return null;
                }),
                _buildInputField("Password", controller: _passwordController, obscure: true, validator: (val) {
                  if (val == null || val.length < 6) return 'Password must be at least 6 characters';
                  return null;
                }),
                _buildDropdownField("Wilaya", wilayas, _selectedWilaya, (val) {
                  setState(() => _selectedWilaya = val);
                }),
                _buildDropdownField("Type", types, _selectedType, (val) {
                  setState(() {
                    _selectedType = val;
                    _selectedService = null; // Reset service on type change
                  });
                }),
                if (_selectedType == 'Worker')
                  _buildDropdownField("Service", services, _selectedService, (val) {
                    setState(() => _selectedService = val);
                  }),
                const SizedBox(height: 20),
                _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text("Sign up", style: TextStyle(fontSize: 16)),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


