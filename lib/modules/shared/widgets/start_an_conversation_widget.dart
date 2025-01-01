import 'package:flutter/material.dart';

class StartAnConversationWidget extends StatefulWidget {
  const StartAnConversationWidget({super.key, required this.title, required this.subtitle, required this.icon});
  final String title;
  final String? subtitle;
  final Widget icon;
  @override
  State<StartAnConversationWidget> createState() => _StartAnConversationWidgetState();
}

class _StartAnConversationWidgetState extends State<StartAnConversationWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.icon,
        const SizedBox(height: 10),
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        if (widget.subtitle != null)
          Text(
            widget.subtitle!,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
      ],
    );
  }
}
