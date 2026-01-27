import 'package:flutter/material.dart';
import 'package:hiot/providers/settings_provider.dart';
import '../data/database.dart';

class BibleProvider extends ChangeNotifier {
  final AppDatabase db;
  final SettingsProvider? settings; // Reference to settings

  String _selectedBook = "Genesis";
  int _selectedChapter = 1;
  int _selectedVerse = 1;
  List<ContentData> _currentVerseWords = [];

  BibleProvider(this.db, this.settings) {
    if (settings != null && settings!.isLoaded) {
       // Restore last position
       _selectedBook = settings!.lastBook;
       _selectedChapter = settings!.lastChapter;
       _selectedVerse = settings!.lastVerse;
       loadVerse();
    }
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

// Cache for the book list
List<String> _books = [];
List<String> get books => _books;

// 1. Load the list of books from the DB
Future<void> loadBooks() async {
  if (_books.isNotEmpty) return;
  
  // Custom query to get distinct book names ordered by ID
  final result = await db.customSelect(
    'SELECT DISTINCT name FROM books ORDER BY nr ASC',
    readsFrom: {db.books},
  ).get();
  
  _books = result.map((row) => row.read<String>('name')).toList();
  notifyListeners();
}

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