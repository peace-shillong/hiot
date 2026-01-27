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
}