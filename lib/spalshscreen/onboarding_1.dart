import 'package:flutter/material.dart';
import 'onboarding_2.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text("Skip"),
              ),
            ),
            const Spacer(),
            Image.asset('lib/asset/1.png', height: 300 , width: 300,),
            const SizedBox(height: 70),
            const Text(
              "Connect with reliable\nhandymen in your area.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 5, 65, 114),
              radius: 25,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Onboarding2()),
                  );
                },
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
