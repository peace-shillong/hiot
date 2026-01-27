import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bible_provider.dart';
import 'interlinear_word.dart';

class VerseDisplayPane extends StatelessWidget {
  const VerseDisplayPane({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the provider for changes
    final provider = context.watch<BibleProvider>();
    final words = provider.currentVerseWords;

    if (words.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Verse Reference
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              "${provider.selectedBook} ${provider.selectedChapter}:${provider.selectedVerse}",
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
          
          // Main Content: The Flowing Interlinear Text
          Expanded(
            child: SingleChildScrollView(
              child: Directionality(
                // FORCE Right-to-Left layout for the Wrap flow
                textDirection: TextDirection.rtl, 
                child: Wrap(
                  spacing: 8.0, // Horizontal space between words
                  runSpacing: 16.0, // Vertical space between lines
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.start,
                  children: words.map((wordData) {
                    return InterlinearWord(wordData: wordData);
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}