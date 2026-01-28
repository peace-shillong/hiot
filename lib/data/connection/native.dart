import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

QueryExecutor connect() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'ot.sqlite'));

    // DEBUG PRINT 1: Where are we looking?
    print("📂 Database path: ${file.path}");

    // Check if file exists
    if (await file.exists()) {
      final size = await file.length();
      print("ℹ️ File exists. Size: $size bytes");
      
      // CRITICAL FIX: If file is 0 bytes (empty), delete it so we can copy fresh.
      if (size == 0) {
        print("⚠️ File is empty. Deleting...");
        await file.delete();
      }
    }

    // Copy Logic
    if (!await file.exists()) {
      print("⚠️ Copying database from assets...");
      try {
        // Load from asset bundle
        final data = await rootBundle.load('assets/database/ot.sqlite');
        // Convert to bytes
        final bytes = data.buffer.asUint8List();
        // Write to storage
        await file.writeAsBytes(bytes, flush: true);
        print("✅ Database copied! New Size: ${await file.length()} bytes");
      } catch (e) {
        print("❌ ERROR copying database: $e");
      }
    }
    
    return NativeDatabase(file);
  });
}