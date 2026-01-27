import 'package:flutter/material.dart';
import 'package:hiot/providers/settings_provider.dart';
import 'package:provider/provider.dart';
import 'data/database.dart';
import 'providers/bible_provider.dart';
import 'ui/responsive_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  
  // We can await generic preferences here if needed, or let providers handle it.
  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        // BibleProvider needs access to SettingsProvider to load initial state
        ChangeNotifierProxyProvider<SettingsProvider, BibleProvider>(
          create: (context) => BibleProvider(database, null),
          update: (context, settings, previous) => BibleProvider(database, settings),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hebrew Interlinear Bible',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal, // Modern Material 3 look
      ),
      home: const ResponsiveLayout(),
    );
  }
}