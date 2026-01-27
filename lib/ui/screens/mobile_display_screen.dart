import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bible_provider.dart';
import '../widgets/verse_display_pane.dart';

class MobileDisplayScreen extends StatelessWidget {
  const MobileDisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BibleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text("${provider.selectedBook} ${provider.selectedChapter}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () { /* Implement Share Logic */ },
          )
        ],
      ),
      // PageView allows swiping left/right
      body: PageView.builder(
        // We act as if there are infinite pages, but we anchor to the current selection
        controller: PageController(initialPage: provider.selectedVerse),
        onPageChanged: (index) {
          if (index > provider.selectedVerse) {
            context.read<BibleProvider>().nextVerse();
          } else {
            context.read<BibleProvider>().previousVerse();
          }
        },
        itemBuilder: (context, index) {
          // We return the same DisplayPane; the Provider updates the content automatically
          // when nextVerse() is called in onPageChanged.
          return const VerseDisplayPane();
        },
      ),
    );
  }
}