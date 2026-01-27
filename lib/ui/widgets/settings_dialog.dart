import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return AlertDialog(
      title: const Text("Settings"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Hebrew Font Size"),
          Slider(
            value: settings.fontSize,
            min: 14.0,
            max: 40.0,
            divisions: 13,
            label: settings.fontSize.round().toString(),
            onChanged: (value) {
              context.read<SettingsProvider>().setFontSize(value);
            },
          ),
          Text(
            "בְּרֵאשִׁית בָּרָא אֱלֹהִים", // Sample text
            style: TextStyle(fontSize: settings.fontSize),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Done"),
        ),
      ],
    );
  }
}