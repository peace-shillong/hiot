import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bible_provider.dart';

class ModernSelectionGrid extends StatefulWidget {
  final VoidCallback onSelectionComplete;

  const ModernSelectionGrid({super.key, required this.onSelectionComplete});

  @override
  State<ModernSelectionGrid> createState() => _ModernSelectionGridState();
}

class _ModernSelectionGridState extends State<ModernSelectionGrid> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // 3 Tabs: Book, Chapter, Verse
    _tabController = TabController(length: 3, vsync: this);

    // ✅ FIX: Load books immediately when this sheet opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<BibleProvider>();
      // Only load if empty to prevent unnecessary reloading
      if (provider.books.isEmpty) {
        provider.loadBooks();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _nextTab() {
    if (_tabController.index < 2) {
      _tabController.animateTo(_tabController.index + 1);
    } else {
      // If we are on the last tab (Verse) and select one, we are done.
      widget.onSelectionComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BibleProvider>();

    return Column(
      mainAxisSize: MainAxisSize.min, // Important for BottomSheet
      children: [
        // 1. The Tabs
        TabBar(
          controller: _tabController,
          labelColor: Colors.teal,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.teal,
          tabs: [
            Tab(text: provider.selectedBook),
            Tab(text: "Ch ${provider.selectedChapter}"),
            Tab(text: "V ${provider.selectedVerse}"),
          ],
        ),
        
        // 2. The Views
        SizedBox(
          height: 400, // Fixed height for the grid area
          child: TabBarView(
            controller: _tabController,
            children: [
              // --- BOOK SELECTION (LIST) ---
              _buildBookList(provider),

              // --- CHAPTER SELECTION (GRID) ---
              _buildGrid(
                items: provider.availableChapters,
                selectedItem: provider.selectedChapter,
                onTap: (val) {
                  provider.updateSelection(provider.selectedBook, val, 1); // Reset verse to 1
                  provider.loadVerses(provider.selectedBook, val); // Load verses for next step
                  _nextTab();
                },
              ),

              // --- VERSE SELECTION (GRID) ---
              _buildGrid(
                items: provider.availableVerses,
                selectedItem: provider.selectedVerse,
                onTap: (val) {
                  provider.updateSelection(provider.selectedBook, provider.selectedChapter, val);
                  widget.onSelectionComplete();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookList(BibleProvider provider) {
    if (provider.books.isEmpty) return const Center(child: CircularProgressIndicator());

    // Handle empty state (e.g. database error)
    if (provider.books.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("No books found"),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => provider.loadBooks(), 
              child: const Text("Retry")
            )
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: provider.books.length,
      itemBuilder: (context, index) {
        final book = provider.books[index];
        final isSelected = book == provider.selectedBook;
        
        return ListTile(
          title: Text(
            book,
            style: TextStyle(
              color: isSelected ? Colors.teal : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          trailing: isSelected ? const Icon(Icons.check, color: Colors.teal) : null,
          onTap: () {
            // Update Book, Reset Chapter/Verse to 1
            provider.updateSelection(book, 1, 1);
            // Load Chapters for this book
            provider.loadChapters(book); 
            // Move to next tab
            _nextTab();
          },
        );
      },
    );
  }

  Widget _buildGrid({
    required List<int> items,
    required int selectedItem,
    required Function(int) onTap,
  }) {
    if (items.isEmpty) return const Center(child: CircularProgressIndicator());

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5, // 5 buttons per row
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final val = items[index];
        final isSelected = val == selectedItem;

        return InkWell(
          onTap: () => onTap(val),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.teal : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Colors.teal : Colors.grey.shade300,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              "$val",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        );
      },
    );
  }
}