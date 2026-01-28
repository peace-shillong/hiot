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
      // final tables = await db.customSelect(
      //   "SELECT name FROM sqlite_master WHERE type='table' AND name='books';"
      // ).get();
      // print("🔍 DEBUG: Found table 'books'? ${tables.isNotEmpty}");

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

  // Add these to your BibleProvider class

// 2. Navigation Logic (Next/Previous Verse)
void nextVerse() {
  // Logic to handle end-of-chapter would go here. 
  // For now, we simply increment the verse.
  updateSelection(_selectedBook, _selectedChapter, _selectedVerse + 1);
}

void previousVerse() {
  if (_selectedVerse > 1) {
    updateSelection(_selectedBook, _selectedChapter, _selectedVerse - 1);
  }
}
}