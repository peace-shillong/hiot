import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/database.dart';
import '../../providers/bible_provider.dart';
import 'interlinear_word.dart';

class VerseDisplayPane extends StatelessWidget {
  // When null, the pane watches BibleProvider for the currently selected
  // verse (used by the web/desktop reading pane). When provided, it renders
  // this exact, already-fetched content instead — used by the mobile swipe
  // view so the previous/next pages show real neighbor content immediately,
  // rather than a stale copy of the current verse that only updates once
  // the page-change animation has already committed.
  final List<ContentData>? words;
  final String? book;
  final int? chapter;
  final int? verse;

  const VerseDisplayPane({
    super.key,
    this.words,
    this.book,
    this.chapter,
    this.verse,
  });

  @override
  Widget build(BuildContext context) {
    List<ContentData> words = this.words ?? const [];
    String book = this.book ?? "";
    int chapter = this.chapter ?? 0;
    int verse = this.verse ?? 0;

    if (this.words == null) {
      // Fall back to watching the provider for the current selection.
      final provider = context.watch<BibleProvider>();
      words = provider.currentVerseWords;
      book = provider.selectedBook;
      chapter = provider.selectedChapter;
      verse = provider.selectedVerse;
    }

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
              "$book $chapter:$verse",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Main Content: The Flowing Interlinear Text
          Expanded(
            child: SingleChildScrollView(
              // FIX 1: Add bottom padding for scrolling space
              padding: const EdgeInsets.only(bottom: 100.0),
              child: Directionality(
                // FORCE Right-to-Left layout for the Wrap flow
                textDirection: TextDirection.rtl, 
                child: Wrap(
                  spacing: 8.0, // Horizontal space between words
                  runSpacing: 16.0, // Vertical space between lines
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.start,
                  children: words.map((wordData) {
                    return InterlinearWord(wordData,wordData: wordData);
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