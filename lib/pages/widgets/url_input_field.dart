import 'package:flutter/material.dart';

class UrlInputField extends StatelessWidget {
  const UrlInputField({
    super.key,
    required this.controller,
    required this.onSendPressed,
    required this.isShortening,
  });

  final TextEditingController controller;
  final VoidCallback onSendPressed;
  final bool isShortening;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        spacing: 4,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter URL to shorten...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 48,
            height: 48,
            child: isShortening
                ? Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    onPressed: onSendPressed,
                    icon: const Icon(Icons.send_rounded),
                    tooltip: 'Shorten URL',
                  ),
          ),
        ],
      ),
    );
  }
}
