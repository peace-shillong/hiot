import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For ByteData
import 'package:hiot/providers/settings_provider.dart';
import 'package:hiot/ui/widgets/interlinear_word.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart'; // Import
import 'package:share_plus/share_plus.dart'; // Import
import 'package:path_provider/path_provider.dart'; // Import
import '../../providers/bible_provider.dart';
import '../widgets/verse_display_pane.dart';

class MobileDisplayScreen extends StatefulWidget {
  const MobileDisplayScreen({super.key});

  @override
  State<MobileDisplayScreen> createState() => _MobileDisplayScreenState();
}

class _MobileDisplayScreenState extends State<MobileDisplayScreen> {
  // 1. Create Controller
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BibleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text("${provider.selectedBook} ${provider.selectedChapter}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            // 2. Attach Share Logic
            onPressed: _shareImage, 
          )
        ],
      ),
      // 3. Wrap Body in Screenshot Widget
      body: Screenshot(
        controller: _screenshotController,
        // We use a white container background to ensure captured image isn't transparent
        child: Container(
          color: Colors.white, 
          child: PageView.builder(
            controller: PageController(initialPage: provider.selectedVerse),
            // Inside build() -> PageView.builder -> onPageChanged:

            onPageChanged: (index) async {
              final provider = context.read<BibleProvider>();
              String? message;

              if (index > provider.selectedVerse) {
                message = await provider.nextVerse();
              } else {
                message = await provider.previousVerse();
              }

              // If a message was returned, show it and force the page back
              if (message != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                // Important: If we hit the wall, the PageView might have visually slid 
                // to a "blank" next page. We need to force it back to the current verse.
                // (However, since we are rebuilding the widget with the SAME verse, 
                // Flutter usually handles the snap back automatically).
              }
            },
            itemBuilder: (context, index) {
              return const VerseDisplayPane();
            },
          ),
        ),
      ),
    );
  }

  // 4. Share Logic Implementation
  // Inside MobileDisplayScreen State class

  Future<void> _shareImage() async {
    final provider = context.read<BibleProvider>();
    final settings = context.read<SettingsProvider>();
    
    final themeData = Theme.of(context);
    final mediaQueryData = MediaQuery.of(context);
    final screenWidth = mediaQueryData.size.width;

    try {
      showDialog(
        context: context, 
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator(color: Colors.white)),
      );

      // --- 1. BUILD THE CONTENT ---
      // This is the clean column of text we want to capture
      final longContent = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              "${provider.selectedBook} ${provider.selectedChapter}:${provider.selectedVerse}",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
          ),
          const Divider(height: 0, thickness: 2),
          const Center(
            child: Text("Shared via Hebrew Interlinear OT", style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Wrap(
              spacing: 4.0, 
              runSpacing: 12.0,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: provider.currentVerseWords.map((word) {
                 return InterlinearWord(word, wordData: word,); 
              }).toList(),
            ),
          ),
                          
        ],
      );

      // --- 2. CAPTURE WITH OVERFLOW BOX ---
      final Uint8List imageBytes = await _screenshotController.captureFromWidget(
        ChangeNotifierProvider.value(
          value: settings,
          child: MediaQuery(
            // We give it a huge virtual height so MediaQuery lookups don't fail
            data: mediaQueryData.copyWith(size: Size(screenWidth, 50000)),
            child: Theme(
              data: themeData,
              // OverflowBox allows the child to be bigger than the screen
              child: OverflowBox(
                minWidth: screenWidth,
                maxWidth: screenWidth,
                minHeight: 0,
                maxHeight: double.infinity, // Infinite height allowed!
                alignment: Alignment.topCenter, // Start from top (Fixes top/bottom clip)
                child: Material(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: longContent,
                  ),
                ),
              ),
            ),
          ),
        ),
        delay: const Duration(milliseconds: 50),
        pixelRatio: 2.0,
      );

      if (mounted) Navigator.pop(context);

      // --- 3. SAVE AND SHARE ---
      final directory = await getTemporaryDirectory();
      final fileName = 'verse_${DateTime.now().millisecondsSinceEpoch}.png';
      final imagePath = await File('${directory.path}/$fileName').create();
      await imagePath.writeAsBytes(imageBytes);

      await Share.shareXFiles(
          [XFile(imagePath.path)], 
          text: 'Read ${provider.selectedBook} ${provider.selectedChapter}:${provider.selectedVerse} in Hebrew!',
      );

    } catch (e) {
      if (mounted && Navigator.canPop(context)) Navigator.pop(context);
      print("❌ SHARE ERROR: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Share failed: $e")));
      }
    }
  }

}