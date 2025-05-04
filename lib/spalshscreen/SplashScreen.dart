import 'package:flutter/material.dart';
import 'onboarding_1.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF2C3A8C),
        child: Column(
          children: [
            const SizedBox(height: 350,),
            const Text(
              'SERVILI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(), 
            Padding(
              padding: const EdgeInsets.only(bottom: 40), 
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 25,
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.blue),
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
      ),
    );
  }
}
