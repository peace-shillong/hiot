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
  String? tempBook;
  int tempChapter = 1;
  int tempVerse = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Trigger the initial load chain
      context.read<BibleProvider>().loadBooks().then((_) {
        // Sync local state with provider defaults after load
        final provider = context.read<BibleProvider>();
        if (mounted && provider.books.isNotEmpty) {
           setState(() {
             tempBook = provider.selectedBook;
             tempChapter = provider.selectedChapter;
             tempVerse = provider.selectedVerse;
           });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider for changes in available counts (chapters/verses)
    final provider = context.watch<BibleProvider>();
    print("🎨 UI Building with Provider Instance: ${provider.hashCode}. Book count: ${provider.books.length}");
    
    // 1. Handle Loading State gracefully
    // Only show full loader if we have absolutely zero books
    if (provider.isLoading && provider.books.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    
    // Safety: If load failed or empty
    if (provider.books.isEmpty) {
      return const Center(child: Text("No books found in database."));
    }

    // Ensure tempBook is valid
    final currentBook = tempBook ?? provider.books.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // --- BOOK DROPDOWN ---
        DropdownButtonFormField<String>(
          value: provider.books.contains(currentBook) ? currentBook : null,
          decoration: const InputDecoration(labelText: "Select Book", border: OutlineInputBorder()),
          items: provider.books.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
          onChanged: (newBook) {
            if (newBook != null && newBook != tempBook) {
              setState(() {
                tempBook = newBook;
                tempChapter = 1; // Reset to safe default immediately
                tempVerse = 1;
              });
              // Trigger cascading load for chapters
              provider.loadChapters(newBook).then((_) {
                 // Update tempChapter to the first available one from the new list
                 if (mounted) {
                   setState(() {
                     tempChapter = provider.availableChapters.first;
                   });
                 }
              });
            }
          },
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            // --- CHAPTER DROPDOWN ---
            Expanded(
              child: DropdownButtonFormField<int>(
                // Ensure value exists in the new list, else default to first
                value: provider.availableChapters.contains(tempChapter) 
                    ? tempChapter 
                    : provider.availableChapters.first,
                decoration: const InputDecoration(labelText: "Chapter", border: OutlineInputBorder()),
                // Map from the ACTUAL LIST of chapters, not a generated range
                items: provider.availableChapters.map((c) => DropdownMenuItem(value: c, child: Text("$c"))).toList(),
                onChanged: (newChapter) {
                  if (newChapter != null) {
                    setState(() {
                      tempChapter = newChapter;
                      tempVerse = 1;
                    });
                    // Trigger cascading load for verses
                    provider.loadVerses(currentBook, newChapter).then((_) {
                        if (mounted) {
                           setState(() {
                             tempVerse = provider.availableVerses.first;
                           });
                        }
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 16),

            // --- VERSE DROPDOWN ---
            Expanded(
              child: DropdownButtonFormField<int>(
                value: provider.availableVerses.contains(tempVerse) 
                    ? tempVerse 
                    : provider.availableVerses.first,
                decoration: const InputDecoration(labelText: "Verse", border: OutlineInputBorder()),
                items: provider.availableVerses.map((v) => DropdownMenuItem(value: v, child: Text("$v"))).toList(),
                onChanged: (newVerse) {
                  if (newVerse != null) {
                    setState(() => tempVerse = newVerse);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        ElevatedButton.icon(
          onPressed: () {
            // Commit to provider
            provider.updateSelection(currentBook, tempChapter, tempVerse);
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