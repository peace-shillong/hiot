import 'package:flutter/material.dart';
import 'modern_selection_grid.dart';

class SelectionSidebar extends StatelessWidget {
  const SelectionSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Header Area
          Container(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16), // Top padding for visual balance
            color: Colors.teal.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bible Books",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Select a book to read, once chapter and verse is selected, the content will display automatically.",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.teal.shade700,
                      ),
                ),
              ],
            ),
          ),
          
          // 2. The Grid (Takes remaining space)
          // We use Flexible to ensure it fills the space but respects boundaries
          Flexible(
            fit: FlexFit.tight,
            child: ModernSelectionGrid(
              onSelectionComplete: () {
                // Empty for Web (Auto-updates via Provider)
              },
            ),
          ),
        ],
      ),
    );
  }
}