// import 'dart:io';
import 'package:drift/drift.dart';
import 'connection/connection.dart' as impl;
// import 'package:drift/native.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as p;

part 'database.g.dart';

// 1. Table Definitions based on your schema
class Books extends Table {
  IntColumn get nr => integer()();
  TextColumn get name => text()();
}

class Content extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get book => text()();
  IntColumn get chapter => integer()();
  IntColumn get verse => integer()();
  IntColumn get wordnr => integer()();
  TextColumn get word => text()();
  TextColumn get concordance => text()();
  TextColumn get translit => text()();
  TextColumn get strongs => text()();
  TextColumn get lemma => text()();
}

class Strongs extends Table {
  TextColumn get id => text()(); // Stores "H1", "H1961", etc.
  TextColumn get tag => text()();
}

@DriftDatabase(tables: [Books, Content, Strongs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(impl.connect());

  @override
  int get schemaVersion => 1;

  // ADD THIS BLOCK
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        // INTENTIONALLY EMPTY
        // Since the database is pre-populated, we don't need Drift to create tables.
        // If we let it run, it might crash trying to create tables that already exist.
      },
      beforeOpen: (details) async {
        // Good practice to enable foreign keys
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  // Query to get words for a specific verse
  Future<List<ContentData>> getVerse(String bookName, int chapter, int verse) {
    return (select(content)
          ..where((t) => t.book.equals(bookName))
          ..where((t) => t.chapter.equals(chapter))
          ..where((t) => t.verse.equals(verse))
          ..orderBy([(t) => OrderingTerm(expression: t.wordnr)]))
        .get();
  }

  // Query to get Strongs definition
  Future<Strong?> getStrongsDefinition(String strongsNumber) {
    // Prefixing with 'H' as per your data requirement
    final lookupId = strongsNumber.startsWith('H') ? strongsNumber : 'H$strongsNumber';
    return (select(strongs)..where((t) => t.id.equals(lookupId))).getSingleOrNull();
  }

  // Inside AppDatabase class

  // 1. Get All Books (Already likely exists, but ensuring it matches)
  Future<List<String>> getAllBooks() async {
    final result = await customSelect(
      'SELECT DISTINCT name FROM books ORDER BY nr ASC',
      readsFrom: {books},
    ).get();
    return result.map((row) => row.read<String>('name')).toList();
  }

  // 2. Get Distinct Chapters for a Book
  Future<List<int>> getChaptersForBook(String bookName) async {
    // Logic: Select distinct chapter from content where book = bookName
    final query = selectOnly(content, distinct: true)
      ..addColumns([content.chapter])
      ..where(content.book.equals(bookName))
      ..orderBy([OrderingTerm(expression: content.chapter, mode: OrderingMode.asc)]);

    final result = await query.get();
    
    // Convert rows to List<int>
    return result.map((row) => row.read(content.chapter)!).toList();
  }

  // 3. Get Distinct Verses for a Book + Chapter
  Future<List<int>> getVersesForChapter(String bookName, int chapterNum) async {
    // Logic: Select distinct verse from content where book = bookName AND chapter = chapterNum
    final query = selectOnly(content, distinct: true)
      ..addColumns([content.verse])
      ..where(content.book.equals(bookName) & content.chapter.equals(chapterNum))
      ..orderBy([OrderingTerm(expression: content.verse, mode: OrderingMode.asc)]);

    final result = await query.get();
    
    return result.map((row) => row.read(content.verse)!).toList();
  }

}