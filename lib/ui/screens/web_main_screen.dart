import 'package:flutter/material.dart';
import 'package:hiot/ui/widgets/settings_dialog.dart';
import '../widgets/selection_sidebar.dart';
import '../widgets/verse_display_pane.dart';

class WebMainScreen extends StatelessWidget {
  const WebMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hebrew Interlinear Old Testament"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () { 
              showDialog(
                context: context,
                builder: (context) => const SettingsDialog(),
              );
             },
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar: 300px width fixed selection area
          const SizedBox(
            width: 300,
            child: SelectionSidebar(), 
          ),
          const VerticalDivider(width: 1),
          // Content: Expanded reading area
          const Expanded(
            child: VerseDisplayPane(),
          ),
        ],
      ),
    );
  }
}