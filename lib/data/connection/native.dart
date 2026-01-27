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

    // Copy from assets if it doesn't exist
    if (!await file.exists()) {
      final data = await rootBundle.load('assets/database/ot.sqlite');
      final bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes);
    }
    return NativeDatabase(file);
  });
}