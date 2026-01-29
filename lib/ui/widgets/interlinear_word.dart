import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiot/providers/settings_provider.dart';
import 'package:provider/provider.dart';
import '../../data/database.dart';

class InterlinearWord extends StatelessWidget {
  final ContentData wordData;

  const InterlinearWord(ContentData word, {super.key, required this.wordData});

  @override
  Widget build(BuildContext context) {
    // 1. Handle Punctuation/Spacing Rows (Empty Strongs)
    if (wordData.strongs.trim().isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 4, right: 4),
        child: Text(
          wordData.word,
          style: GoogleFonts.notoSerifHebrew(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    //get fontSize from SettingsProvider
    final fontSize = context.select<SettingsProvider, double>((s) => s.fontSize);

    // 2. Handle Standard Word Rows
    return Container(
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, blurRadius: 2, spreadRadius: 1)
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top: Strong's Number (Clickable)
          InkWell(
            onTap: () => _showStrongsDefinition(context, wordData.strongs),
            child: Text(
              wordData.strongs,
              style: const TextStyle(
                color: Colors.teal,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(height: 4),

          // Middle: Hebrew Word
          // Inside InterlinearWord build method:

          // Apply to Hebrew Text widget:
          Text(
            wordData.word,
            style: GoogleFonts.notoSerifHebrew(
              fontSize: fontSize, 
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 4),

          // Bottom 1: Transliteration
          Text(
            wordData.translit,
            style: const TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),

          // Bottom 2: English Gloss/Concordance
          Text(
            wordData.concordance,
            style: TextStyle(
              fontSize: 13,
              color: Colors.red.shade700,
            ),
          ),

          // Bottom 3: Lemma/Grammar
          Text(
            wordData.lemma,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _showStrongsDefinition(BuildContext context, String strongsId) async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final definition = await db.getStrongsDefinition(strongsId);

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Strong's $strongsId"),
          content: SingleChildScrollView(
            child: Text(definition?.tag ?? "Definition not found."),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        ),
      );
    }
  }
}