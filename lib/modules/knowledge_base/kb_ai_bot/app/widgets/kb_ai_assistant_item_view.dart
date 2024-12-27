import 'package:flutter/material.dart';
import 'package:jarvis_ai/gen/assets.gen.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_assistant.dart';

class KBAIAssistantItemView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onItemTap,
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
            color: assistant.isFavorite ? Colors.yellow : Colors.grey,
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
                      assistant.assistantName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // trim the description if length > 20
                    Text(
                      assistant.description.length > 30 ? "${assistant.description.substring(0, 30)}..." : assistant.description,
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
                // Favorite and Delete Icons
                Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          onFavoriteTap();
                        },
                        child: Icon(
                          assistant.isFavorite ? Icons.star : Icons.star_border_outlined,
                          color: assistant.isFavorite ? Colors.yellow : Colors.grey,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          onDelete();
                        },
                        child: const Icon(
                          Icons.delete,
                          color: Colors.grey,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                _formatDate(assistant.createdAt),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.month}/${date.day}/${date.year}";
  }
}
