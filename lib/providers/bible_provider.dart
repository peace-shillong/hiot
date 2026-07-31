import 'dart:async';

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
  List<ContentData> _nextVerseWords = [];
  List<ContentData> _previousVerseWords = [];
  ({String book, int chapter, int verse})? _nextCoords;
  ({String book, int chapter, int verse})? _previousCoords;

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
  // Pre-fetched neighbor content, so a swipe-in-progress can show the real
  // adjacent verse instead of a stale copy of the current one.
  List<ContentData> get nextVerseWords => _nextVerseWords;
  List<ContentData> get previousVerseWords => _previousVerseWords;
  ({String book, int chapter, int verse})? get nextCoords => _nextCoords;
  ({String book, int chapter, int verse})? get previousCoords => _previousCoords;

  // Setters and Logic
  Future<void> updateSelection(String book, int chapter, int verse) async {
      _selectedBook = book;
      _selectedChapter = chapter;
      _selectedVerse = verse;

      // Save to persistence
      settings?.saveLastPosition(book, chapter, verse);

      await loadVerse();
    }

  Future<void> loadVerse() async {
    _currentVerseWords = await db.getVerse(_selectedBook, _selectedChapter, _selectedVerse);
    notifyListeners();
    // Not awaited: the swipe handler re-centers as soon as the current verse
    // is ready. Awaiting this delayed that until next/previous had already
    // shifted to the new verse, flashing wrong content on the visible page.
    unawaited(_prefetchNeighborVerses());
  }

  // Fetches the actual previous/next verse content so a swipe gesture can
  // display real data throughout the drag instead of a stale copy of the
  // current verse that only updates once the page snap completes.
  Future<void> _prefetchNeighborVerses() async {
    // Both directions are independent, so resolve them concurrently.
    final coords = await Future.wait([_peekNextCoords(), _peekPreviousCoords()]);
    final words = await Future.wait(coords.map(_wordsAt));

    if (_isDisposed) return;
    _nextCoords = coords[0];
    _previousCoords = coords[1];
    _nextVerseWords = words[0];
    _previousVerseWords = words[1];
    notifyListeners();
  }

  Future<List<ContentData>> _wordsAt(
      ({String book, int chapter, int verse})? coords) async {
    if (coords == null) return const [];
    return db.getVerse(coords.book, coords.chapter, coords.verse);
  }

  // Inside BibleProvider class

  // Helper: Get index of current book
  int get _currentBookIndex => _books.indexOf(_selectedBook);

  // Computes where "next" points to, without mutating any state.
  Future<({String book, int chapter, int verse})?> _peekNextCoords() async {
    // 1. Next Verse in same chapter
    if (_selectedVerse < _availableVerses.last) {
      return (book: _selectedBook, chapter: _selectedChapter, verse: _selectedVerse + 1);
    }

    // 2. Next Chapter in same book
    if (_selectedChapter < _availableChapters.last) {
      return (book: _selectedBook, chapter: _selectedChapter + 1, verse: 1);
    }

    // 3. Next Book
    if (_currentBookIndex < _books.length - 1) {
      return (book: _books[_currentBookIndex + 1], chapter: 1, verse: 1);
    }

    // 4. Boundary Reached
    return null;
  }

  // Computes where "previous" points to, without mutating any state.
  Future<({String book, int chapter, int verse})?> _peekPreviousCoords() async {
    // 1. Previous Verse in same chapter
    if (_selectedVerse > 1) {
      return (book: _selectedBook, chapter: _selectedChapter, verse: _selectedVerse - 1);
    }

    // 2. Previous Chapter in same book
    if (_selectedChapter > 1) {
      final prevChapter = _selectedChapter - 1;
      final prevChapterVerses = await db.getVersesForChapter(_selectedBook, prevChapter);
      final lastVerse = prevChapterVerses.isNotEmpty ? prevChapterVerses.last : 1;
      return (book: _selectedBook, chapter: prevChapter, verse: lastVerse);
    }

    // 3. Previous Book
    if (_currentBookIndex > 0) {
      final prevBook = _books[_currentBookIndex - 1];

      final prevBookChapters = await db.getChaptersForBook(prevBook);
      final lastChapter = prevBookChapters.isNotEmpty ? prevBookChapters.last : 1;

      final prevChapterVerses = await db.getVersesForChapter(prevBook, lastChapter);
      final lastVerse = prevChapterVerses.isNotEmpty ? prevChapterVerses.last : 1;

      return (book: prevBook, chapter: lastChapter, verse: lastVerse);
    }

    // 4. Boundary Reached
    return null;
  }

  Future<String?> nextVerse() async {
    final coords = await _peekNextCoords();
    if (coords == null) return "You have reached the end of the Old Testament.";
    await updateSelection(coords.book, coords.chapter, coords.verse);
    return null;
  }

  Future<String?> previousVerse() async {
    final coords = await _peekPreviousCoords();
    if (coords == null) return "You are at the start of the Book.";
    await updateSelection(coords.book, coords.chapter, coords.verse);
    return null;
  }
}