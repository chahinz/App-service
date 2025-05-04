// import 'package:flutter/material.dart';
// import 'signup.dart';
// import 'forgotpassword.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             const SizedBox(height: 50),
//             Image.asset('lib/asset/login.png', height: 300),
//             const Text("Welcome back,", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 32),
//               child: Column(
//                 children: [
//                   TextField(
//                     decoration: InputDecoration(
//                       hintText: "Email",
//                       prefixIcon: Icon(Icons.email),
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   TextField(
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       hintText: "Password",
//                       prefixIcon: Icon(Icons.lock),
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: TextButton(
//                       onPressed: () {
//                          Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
//                   );
//                       },
//                       child: const Text("forgot password?", style: TextStyle(color: Colors.indigo,)),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.indigo,
//                       minimumSize: const Size(double.infinity, 54),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                     ),
//                     child: const Text(
//   "Sign in",
//   style: TextStyle(
//     color: Colors.white,
//     fontWeight: FontWeight.bold,
//   ),
// ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => const SignupScreen()),
//                   );
//                     },
//                     child: const Text("Don't have an account? Sign up", style: TextStyle(color: Colors.indigo)),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:servili/homepage_client/homescreen.dart';
import 'signup.dart';
import 'forgotpassword.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // helps when keyboard appears
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // handle keyboard overlap
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Image.asset('lib/asset/login.png', height: 300),
              const Text(
                "Welcome back,",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(Icons.lock),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ForgotPasswordScreen()),
                          );
                        },
                        child: const Text(
                          "Forgot password?",
                          style: TextStyle(color: Colors.indigo),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                         Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen ()),
                  );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text(
                        "Sign in",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SignupScreen()),
                        );
                      },
                      child: const Text(
                        "Don't have an account? Sign up",
                        style: TextStyle(color: Colors.indigo),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
