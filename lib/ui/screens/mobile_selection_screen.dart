import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bible_provider.dart';
import '../widgets/modern_selection_grid.dart';
import '../widgets/settings_dialog.dart';
import 'mobile_display_screen.dart';
// import 'package:flutter/gestures.dart'; // For TapGestureRecognizer
// import 'package:url_launcher/url_launcher.dart'; // For opening the link
import '../widgets/clickable_link.dart';

class MobileSelectionScreen extends StatelessWidget {
  const MobileSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BibleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hebrew Interlinear OT"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const SettingsDialog(),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: SingleChildScrollView( // Added ScrollView to prevent overflow on small screens
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.menu_book_rounded, size: 80, color: Colors.teal),
              const SizedBox(height: 20),
              Text(
                "Welcome To\nHebrew Interlinear Old Testament",
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.teal.shade700
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // The "Trigger" Button (Now the main interaction)
              InkWell(
                onTap: () {
                  _showSelectionSheet(context);
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.teal),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "SELECT VERSE",
                        style: TextStyle(color: Colors.teal.shade700, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${provider.selectedBook} ${provider.selectedChapter}:${provider.selectedVerse}",
                        style: const TextStyle(
                          fontSize: 28, // Made slightly bigger
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text("Tap to change and open verse", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              
              // Info Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    // Inside your Column children:
                    const ClickableLink(
                      textBefore: 'An updated version of the repository of @ ',
                      linkText: 'github.com/stefankmitph/hiot',
                      url: 'https://github.com/stefankmitph/hiot',
                    ),
                    const SizedBox(height: 10),
                    const ClickableLink(
                      textBefore: 'Feel free to support & give feedback @ ',
                      linkText: 'github.com/peace-shillong/hiot',
                      url: 'https://github.com/peace-shillong/hiot',
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Free and open source version of the Hebrew Old Testament including Strong\'s references, concordances, transliteration and lemmas.',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'This app was created with assistance from Gemini AI.',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- THE FIXED LOGIC IS HERE ---
  void _showSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return ModernSelectionGrid(
              onSelectionComplete: () {
                // 1. Close the Bottom Sheet
                Navigator.pop(context); 

                // 2. Immediately Navigate to the Reading View
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MobileDisplayScreen()),
                );
              },
            );
          },
        );
      },
    );
  }
}