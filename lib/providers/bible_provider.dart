import 'package:flutter/material.dart';
import 'package:hiot/providers/settings_provider.dart';
import '../data/database.dart';

class BibleProvider extends ChangeNotifier {
  final AppDatabase db;
  SettingsProvider? settings; // Reference to settings

  String _selectedBook = "Genesis";
  int _selectedChapter = 1;
  int _selectedVerse = 1;
  List<ContentData> _currentVerseWords = [];

  // NEW: State for Dropdowns
  List<String> _books = [];
  List<int> _availableChapters = [1];
  List<int> _availableVerses = [1];

  // Getters
  List<String> get books => _books;
  List<int> get availableChapters => _availableChapters;
  List<int> get availableVerses => _availableVerses;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // 1. ADD THIS FLAG
  bool _isDisposed = false;

  // 2. OVERRIDE DISPOSE
  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
  
  // 3. UPDATE loadBooks TO CHECK THE FLAG
  Future<void> loadBooks() async {
    // Print the ID of this provider instance
    print("📢 Provider Instance Hash: $hashCode - Starting loadBooks");
    if (_isDisposed) {
        print("⚠️ Provider $hashCode is DISPOSED. Aborting.");
        return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // --- DEBUG START: Run a raw SQL check ---
      print("🔍 DEBUG: Attempting to query 'books' table...");
      
      // // 1. Check if table exists
      final tables = await db.customSelect(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='books';"
      ).get();
      print("🔍 DEBUG: Found table 'books'? ${tables.isNotEmpty}");

      // // 2. Count rows
      // final count = await db.customSelect("SELECT count(*) as c FROM books").getSingle();
      // print("🔍 DEBUG: Row count in books: ${count.read<int>('c')}");
      // // --- DEBUG END ---

      _books = await db.getAllBooks();
      print("✅ Provider $hashCode loaded ${_books.length} books");
      // print("🔍 DEBUG: getAllBooks() returned ${_books.length} books"); // Check the final list

      
    } catch (e) {
      print("❌ CRITICAL ERROR in loadBooks: $e");
    } finally {
      if (!_isDisposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  // 5. Apply the same check to other async methods
  Future<void> loadChapters(String bookName) async {
    if (_isDisposed) return;
    
    _availableChapters = await db.getChaptersForBook(bookName);
    if (_availableChapters.isEmpty) _availableChapters = [1];

    int targetChapter = _availableChapters.contains(_selectedChapter) 
        ? _selectedChapter 
        : _availableChapters.first;
        
    await loadVerses(bookName, targetChapter);
    
    // Safety check
    if (!_isDisposed) notifyListeners(); 
  }

  Future<void> loadVerses(String bookName, int chapterNum) async {
    if (_isDisposed) return;

    _availableVerses = await db.getVersesForChapter(bookName, chapterNum);
    if (_availableVerses.isEmpty) _availableVerses = [1];
    
    // Safety check
    if (!_isDisposed) notifyListeners();
  }

  BibleProvider(this.db, this.settings);

  // NEW: Method to update settings without killing the provider
  void updateSettings(SettingsProvider newSettings) {
    settings = newSettings;
    // You can also apply logic here, e.g., if (newSettings.lastBook != _selectedBook) ...
    notifyListeners();
  }

  // Getters
  String get selectedBook => _selectedBook;
  int get selectedChapter => _selectedChapter;
  int get selectedVerse => _selectedVerse;
  List<ContentData> get currentVerseWords => _currentVerseWords;

  // Setters and Logic
  void updateSelection(String book, int chapter, int verse) {
      _selectedBook = book;
      _selectedChapter = chapter;
      _selectedVerse = verse;
      
      // Save to persistence
      settings?.saveLastPosition(book, chapter, verse);
      
      loadVerse();
    }

  Future<void> loadVerse() async {
    _currentVerseWords = await db.getVerse(_selectedBook, _selectedChapter, _selectedVerse);
    notifyListeners();
  }

  // Inside BibleProvider class

  // Helper: Get index of current book
  int get _currentBookIndex => _books.indexOf(_selectedBook);

  // 1. ROBUST NEXT VERSE LOGIC
  // Update the return type to Future<String?>
  Future<String?> nextVerse() async {
    // 1. Next Verse in same chapter
    if (_selectedVerse < _availableVerses.last) {
      updateSelection(_selectedBook, _selectedChapter, _selectedVerse + 1);
      return null; // Success
    }

    // 2. Next Chapter in same book
    if (_selectedChapter < _availableChapters.last) {
      updateSelection(_selectedBook, _selectedChapter + 1, 1);
      return null; // Success
    }

    // 3. Next Book
    if (_currentBookIndex < _books.length - 1) {
      final nextBook = _books[_currentBookIndex + 1];
      updateSelection(nextBook, 1, 1);
      return null; // Success
    }

    // 4. Boundary Reached
    return "You have reached the end of the Old Testament.";
  }

  Future<String?> previousVerse() async {
    // 1. Previous Verse in same chapter
    if (_selectedVerse > 1) {
      updateSelection(_selectedBook, _selectedChapter, _selectedVerse - 1);
      return null; // Success
    }

    // 2. Previous Chapter in same book
    if (_selectedChapter > 1) {
      final prevChapter = _selectedChapter - 1;
      final prevChapterVerses = await db.getVersesForChapter(_selectedBook, prevChapter);
      final lastVerse = prevChapterVerses.isNotEmpty ? prevChapterVerses.last : 1;
      
      updateSelection(_selectedBook, prevChapter, lastVerse);
      return null; // Success
    }

    // 3. Previous Book
    if (_currentBookIndex > 0) {
      final prevBook = _books[_currentBookIndex - 1];
      
      final prevBookChapters = await db.getChaptersForBook(prevBook);
      final lastChapter = prevBookChapters.isNotEmpty ? prevBookChapters.last : 1;
      
      final prevChapterVerses = await db.getVersesForChapter(prevBook, lastChapter);
      final lastVerse = prevChapterVerses.isNotEmpty ? prevChapterVerses.last : 1;

      updateSelection(prevBook, lastChapter, lastVerse);
      return null; // Success
    }

    // 4. Boundary Reached
    return "You are at the start of the Book.";
  }

  // Future<void> nextVerse() async {
  //   // Case A: Next Verse in same chapter
  //   if (_selectedVerse < _availableVerses.last) {
  //     updateSelection(_selectedBook, _selectedChapter, _selectedVerse + 1);
  //     return;
  //   }

  //   // Case B: Next Chapter in same book
  //   if (_selectedChapter < _availableChapters.last) {
  //     // Go to next chapter, Verse 1
  //     updateSelection(_selectedBook, _selectedChapter + 1, 1);
  //     return;
  //   }

  //   // Case C: Next Book
  //   if (_currentBookIndex < _books.length - 1) {
  //     final nextBook = _books[_currentBookIndex + 1];
  //     // Go to Next Book, Chapter 1, Verse 1
  //     updateSelection(nextBook, 1, 1);
  //     return;
  //   }

  //   // Case D: End of Bible (Do nothing or show toast)
  //   print("End of Old Testament reached.");
  // }

  // // 2. ROBUST PREVIOUS VERSE LOGIC
  // Future<void> previousVerse() async {
  //   // Case A: Previous Verse in same chapter
  //   if (_selectedVerse > 1) {
  //     updateSelection(_selectedBook, _selectedChapter, _selectedVerse - 1);
  //     return;
  //   }

  //   // Case B: Previous Chapter in same book
  //   if (_selectedChapter > 1) {
  //     final prevChapter = _selectedChapter - 1;
  //     // We need to find the last verse of the previous chapter
  //     final prevChapterVerses = await db.getVersesForChapter(_selectedBook, prevChapter);
  //     final lastVerse = prevChapterVerses.isNotEmpty ? prevChapterVerses.last : 1;
      
  //     updateSelection(_selectedBook, prevChapter, lastVerse);
  //     return;
  //   }

  //   // Case C: Previous Book
  //   if (_currentBookIndex > 0) {
  //     final prevBook = _books[_currentBookIndex - 1];
      
  //     // Find last chapter of previous book
  //     final prevBookChapters = await db.getChaptersForBook(prevBook);
  //     final lastChapter = prevBookChapters.isNotEmpty ? prevBookChapters.last : 1;
      
  //     // Find last verse of that last chapter
  //     final prevChapterVerses = await db.getVersesForChapter(prevBook, lastChapter);
  //     final lastVerse = prevChapterVerses.isNotEmpty ? prevChapterVerses.last : 1;

  //     updateSelection(prevBook, lastChapter, lastVerse);
  //     return;
  //   }
  // }
}