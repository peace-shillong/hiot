import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/services.dart';

QueryExecutor connect() {
  return DatabaseConnection.delayed(Future(() async {
    // 1. Load the SQLite Wasm binary
    // final response = await rootBundle.load('sqlite3.wasm'); 
    // final wasmBytes = response.buffer.asUint8List();

    // 2. Initialize the Wasm Database
    final result = await WasmDatabase.open(
      databaseName: 'ot_db', 
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'), // Optional: for background thread
      initializeDatabase: () async {
        // print("⚠️ Web: Loading database from assets...");
        try {
          final data = await rootBundle.load('assets/database/ot.sqlite');
          // print("✅ Web: Asset loaded. Size: ${data.lengthInBytes}");
          return data.buffer.asUint8List();
        } catch (e) {
          // print("❌ Web: Error loading asset: $e");
          rethrow;
        }
      },
    );
    
    return result.resolvedExecutor;
  }));
}