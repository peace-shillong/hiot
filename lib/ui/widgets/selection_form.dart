import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bible_provider.dart';

class SelectionForm extends StatefulWidget {
  final VoidCallback onViewPressed;

  const SelectionForm({super.key, required this.onViewPressed});

  @override
  State<SelectionForm> createState() => _SelectionFormState();
}

class _SelectionFormState extends State<SelectionForm> {
  // Temporary state for the dropdowns before user clicks "View"
  String? tempBook;
  int tempChapter = 1;
  int tempVerse = 1;

  @override
  void initState() {
    super.initState();
    // Load books immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BibleProvider>().loadBooks();
      // Initialize temp values from current provider state
      final provider = context.read<BibleProvider>();
      tempBook = provider.selectedBook;
      tempChapter = provider.selectedChapter;
      tempVerse = provider.selectedVerse;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BibleProvider>();
    
    // Default to "Genesis" if books aren't loaded yet
    final currentBook = tempBook ?? (provider.books.isNotEmpty ? provider.books.first : "Genesis");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Book Selector
        DropdownButtonFormField<String>(
          initialValue: provider.books.contains(currentBook) ? currentBook : null,
          decoration: const InputDecoration(labelText: "Select Book", border: OutlineInputBorder()),
          items: provider.books.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
          onChanged: (val) {
            setState(() {
              tempBook = val;
              tempChapter = 1; // Reset chapter when book changes
              tempVerse = 1;
            });
          },
        ),
        const SizedBox(height: 16),

        // 2. Chapter & Verse Row
        Row(
          children: [
            // Chapter Selector
            Expanded(
              child: DropdownButtonFormField<int>(
                initialValue: tempChapter,
                decoration: const InputDecoration(labelText: "Chapter", border: OutlineInputBorder()),
                // Generating 150 chapters for safety (In real app, query DB for max chapters)
                items: List.generate(150, (index) => index + 1)
                    .map((c) => DropdownMenuItem(value: c, child: Text("$c")))
                    .toList(),
                onChanged: (val) => setState(() => tempChapter = val!),
              ),
            ),
            const SizedBox(width: 16),
            // Verse Selector
            Expanded(
              child: DropdownButtonFormField<int>(
                initialValue: tempVerse,
                decoration: const InputDecoration(labelText: "Verse", border: OutlineInputBorder()),
                items: List.generate(176, (index) => index + 1)
                    .map((v) => DropdownMenuItem(value: v, child: Text("$v")))
                    .toList(),
                onChanged: (val) => setState(() => tempVerse = val!),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // 3. View Button
        ElevatedButton.icon(
          onPressed: () {
            // Commit changes to Provider
            context.read<BibleProvider>().updateSelection(
                  tempBook!,
                  tempChapter,
                  tempVerse,
                );
            widget.onViewPressed();
          },
          icon: const Icon(Icons.visibility),
          label: const Text("VIEW VERSE"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}