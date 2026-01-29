import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class ClickableLink extends StatelessWidget {
  final String textBefore;
  final String linkText;
  final String url;
  
  const ClickableLink({
    super.key, 
    required this.textBefore, 
    required this.linkText, 
    required this.url
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5),
        children: [
          TextSpan(text: textBefore),
          TextSpan(
            text: linkText,
            style: const TextStyle(
              color: Colors.teal, 
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final Uri uri = Uri.parse(url);
                try {
                  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                    throw Exception('Could not launch $uri');
                  }
                } catch (e) {
                  print("Error launching URL: $e");
                  // Optional: Show snackbar
                }
              },
          ),
        ],
      ),
    );
  }
}