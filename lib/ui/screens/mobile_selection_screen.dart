import 'package:flutter/material.dart';
import '../widgets/selection_form.dart';
import 'mobile_display_screen.dart'; // We will create this next

class MobileSelectionScreen extends StatelessWidget {
  const MobileSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hebrew Interlinear")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.menu_book_rounded, size: 64, color: Colors.teal),
              const SizedBox(height: 32),
              SelectionForm(
                onViewPressed: () {
                  // Navigate to the swipeable display screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MobileDisplayScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}