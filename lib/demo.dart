import 'package:flutter/material.dart';
import 'package:timer/bottom_bar.dart';
import 'package:timer/timer.dart';

class DemoPage extends StatelessWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Page'),
      ),
      bottomNavigationBar: const BottomBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Page One'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CountdownPage()),
                );
              },
              child: const Text('Timer'),
            ),
          ],
        ),
      ),
    );
  }
}
