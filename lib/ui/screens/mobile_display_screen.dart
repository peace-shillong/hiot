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

  // Infinite-loop trick: the PageView always has exactly 3 pages
  // (previous / current / next). We keep it centered on index 1 and, once a
  // swipe settles on 0 or 2, commit that verse to BibleProvider and jump
  // straight back to the center — instead of recreating the controller (and
  // therefore its scroll position) on every rebuild, which is what caused
  // the previous verse to linger until the drag was already past the
  // halfway point and only then snap to the new one.
  late final PageController _pageController;
  static const int _centerPage = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _centerPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onPageChanged(int index) async {
    if (index == _centerPage) return;

    final provider = context.read<BibleProvider>();
    final message = index > _centerPage
        ? await provider.nextVerse()
        : await provider.previousVerse();

    if (!mounted) return;
    _pageController.jumpToPage(_centerPage);

    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

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
            controller: _pageController,
            itemCount: 3,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              if (index < _centerPage) {
                final coords = provider.previousCoords;
                return VerseDisplayPane(
                  words: provider.previousVerseWords,
                  book: coords?.book,
                  chapter: coords?.chapter,
                  verse: coords?.verse,
                );
              }
              if (index > _centerPage) {
                final coords = provider.nextCoords;
                return VerseDisplayPane(
                  words: provider.nextVerseWords,
                  book: coords?.book,
                  chapter: coords?.chapter,
                  verse: coords?.verse,
                );
              }
              return VerseDisplayPane(
                words: provider.currentVerseWords,
                book: provider.selectedBook,
                chapter: provider.selectedChapter,
                verse: provider.selectedVerse,
              );
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