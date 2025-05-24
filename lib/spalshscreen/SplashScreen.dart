// import 'package:flutter/material.dart';
// import 'onboarding_1.dart';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         color: const Color(0xFF2C3A8C),
//         child: Column(
//           children: [
//             const SizedBox(height: 350,),
//             const Text(
//               'SERVILI',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const Spacer(), 
//             Padding(
//               padding: const EdgeInsets.only(bottom: 40), 
//               child: CircleAvatar(
//                 backgroundColor: Colors.white,
//                 radius: 25,
//                 child: IconButton(
//                   icon: const Icon(Icons.arrow_forward, color: Colors.blue),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => const Onboarding1()),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'onboarding_1.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 243, 252), 
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 250),

              Image.asset(
                'lib/asset/FINALONE.png',
                width: 200,
                height: 150,
              ), 

              const SizedBox(height: 20),

              Center(
                child: Text(
  'SERVILI ',
  style: GoogleFonts.montserrat(
    fontSize: 48,
    fontWeight: FontWeight.bold,  
    color: const Color.fromARGB(255, 5, 65, 114),
  ),
),
              ),

              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 5, 65, 114),
                  radius: 25,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Color.fromARGB(255, 219, 225, 230)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Onboarding1()),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


