import 'package:flutter/material.dart';
import 'screens/mobile_selection_screen.dart';
import 'screens/web_main_screen.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          // Dual-pane view for Web/Desktop
          return const WebMainScreen();
        } else {
          // Single-pane view for Mobile
          return const MobileSelectionScreen();
        }
      },
    );
  }
}