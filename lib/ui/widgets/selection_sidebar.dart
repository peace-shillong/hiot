import 'package:flutter/material.dart';
import 'selection_form.dart';

class SelectionSidebar extends StatelessWidget {
  const SelectionSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Passage Selection",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          // reuse the exact same form as mobile
          SelectionForm(
            onViewPressed: () {
              // On Web, we do nothing here.
              // The form already updated the Provider, which updates the DisplayPane automatically.
            },
          ),
          const Spacer(),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Hebrew Interlinear Old Testament",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}