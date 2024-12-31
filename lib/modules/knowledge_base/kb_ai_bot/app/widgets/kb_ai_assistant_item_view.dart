import 'package:flutter/material.dart';
import 'package:jarvis_ai/gen/assets.gen.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_assistant.dart';

class KBAIAssistantItemView extends StatefulWidget {
  final KBAIAssistant assistant;
  final VoidCallback onDelete;
  final VoidCallback onFavoriteTap;
  final VoidCallback onItemTap;

  const KBAIAssistantItemView({
    super.key,
    required this.assistant,
    required this.onDelete,
    required this.onFavoriteTap,
    required this.onItemTap,
  });

  @override
  State<KBAIAssistantItemView> createState() => _KBAIAssistantItemViewState();
}

class _KBAIAssistantItemViewState extends State<KBAIAssistantItemView> {
  double _dragOffset = 0;
  static const double _maxOffset = 100;
  static const double _threshold = 0.3;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset = (_dragOffset + details.delta.dx).clamp(-_maxOffset, 0.0);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    setState(() {
      if (_dragOffset <= -_maxOffset * _threshold) {
        _dragOffset = -_maxOffset;
      } else {
        _dragOffset = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: widget.onDelete,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(_dragOffset, 0, 0),
          child: GestureDetector(
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            onHorizontalDragEnd: _onHorizontalDragEnd,
            onTap: widget.onItemTap,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: widget.assistant.isFavorite ? Colors.yellow : Colors.grey,
                  width: 0.3,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Assets.images.imgAssistant.image(
                        width: 50,
                        height: 50,
                      ),
                      const SizedBox(width: 12),
                      // Assistant Info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.assistant.assistantName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.assistant.description.length > 30
                                ? "${widget.assistant.description.substring(0, 30)}..."
                                : widget.assistant.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Favorite Icon
                      InkWell(
                        onTap: widget.onFavoriteTap,
                        child: Icon(
                          widget.assistant.isFavorite ? Icons.star : Icons.star_border_outlined,
                          color: widget.assistant.isFavorite ? Colors.yellow : Colors.grey,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _formatDate(widget.assistant.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return "${date.month}/${date.day}/${date.year}";
  }
}
