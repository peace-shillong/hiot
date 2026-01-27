import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const String keyBook = 'last_book';
  static const String keyChapter = 'last_chapter';
  static const String keyVerse = 'last_verse';
  static const String keyFontSize = 'font_size';

  // Default values
  String _lastBook = "Genesis";
  int _lastChapter = 1;
  int _lastVerse = 1;
  double _fontSize = 22.0;

  // Getters
  String get lastBook => _lastBook;
  int get lastChapter => _lastChapter;
  int get lastVerse => _lastVerse;
  double get fontSize => _fontSize;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _lastBook = prefs.getString(keyBook) ?? "Genesis";
    _lastChapter = prefs.getInt(keyChapter) ?? 1;
    _lastVerse = prefs.getInt(keyVerse) ?? 1;
    _fontSize = prefs.getDouble(keyFontSize) ?? 22.0;
    
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> saveLastPosition(String book, int chapter, int verse) async {
    _lastBook = book;
    _lastChapter = chapter;
    _lastVerse = verse;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyBook, book);
    await prefs.setInt(keyChapter, chapter);
    await prefs.setInt(keyVerse, verse);
    // Note: We don't call notifyListeners() here to avoid unnecessary UI rebuilds 
    // since the BibleProvider already handles the immediate UI state.
  }

  Future<void> setFontSize(double size) async {
    _fontSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(keyFontSize, size);
    notifyListeners();
  }
}