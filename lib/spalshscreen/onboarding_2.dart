import 'package:flutter/material.dart';
import 'onboarding_3.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

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
            Image.asset('lib/asset/2.png', height: 300 , width: 300,),
            const SizedBox(height: 20),
            const Text(
              "Hassle-free home\nmaintenance",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 1, 35, 97),
              radius: 25,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Onboarding3()),
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
