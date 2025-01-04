import 'package:flutter/material.dart';
import 'package:jarvis_ai/gen/assets.gen.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_get_kl.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/domain/models/kb_ai_knowledge.dart';

class KnowledgeBaseItemView<T> extends StatefulWidget {
  final T item;
  final VoidCallback onDelete;
  final VoidCallback onFavoriteTap;
  final VoidCallback onEditTap;
  final VoidCallback onItemTap;
  final ValueNotifier<String?> openItemIdNotifier;
  final bool enableSwipeToDelete;

  const KnowledgeBaseItemView({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onFavoriteTap,
    required this.onItemTap,
    required this.openItemIdNotifier,
    required this.onEditTap,
    this.enableSwipeToDelete = true,
  });

  @override
  State<KnowledgeBaseItemView<T>> createState() => _KnowledgeBaseItemViewState<T>();
}

class _KnowledgeBaseItemViewState<T> extends State<KnowledgeBaseItemView<T>> {
  double _dragOffset = 0;
  static const double _maxOffset = 100;
  static const double _threshold = 0.3;

  String getItemId(T item) {
    if (item is KBAIKnowledge) return item.id;
    if (item is ResponseGetKl) return item.id;
    throw UnsupportedError("Unsupported item type");
  }

  String getItemName(T item) {
    if (item is KBAIKnowledge) return item.knowledgeName;
    if (item is ResponseGetKl) return item.knowledgeName;
    throw UnsupportedError("Unsupported item type");
  }

  String? getItemDescription(T item) {
    if (item is KBAIKnowledge) return item.description;
    if (item is ResponseGetKl) return item.description;
    throw UnsupportedError("Unsupported item type");
  }

  DateTime getItemDate(T item) {
    if (item is KBAIKnowledge) return item.createdAt;
    if (item is ResponseGetKl) {
      return DateTime.parse(item.createdAt);
    }
    throw UnsupportedError("Unsupported item type");
  }

  @override
  void initState() {
    super.initState();
    widget.openItemIdNotifier.addListener(_onNotifierChanged);
  }

  @override
  void dispose() {
    widget.openItemIdNotifier.removeListener(_onNotifierChanged);
    super.dispose();
  }

  void _onNotifierChanged() {
    if (widget.openItemIdNotifier.value != getItemId(widget.item)) {
      setState(() {
        _dragOffset = 0;
      });
    }
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (!widget.enableSwipeToDelete) return;
    setState(() {
      _dragOffset = (_dragOffset + details.delta.dx).clamp(-_maxOffset, 0.0);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (!widget.enableSwipeToDelete) return;
    setState(
      () {
        if (_dragOffset <= -_maxOffset * _threshold) {
          _dragOffset = -_maxOffset;
          widget.openItemIdNotifier.value = getItemId(widget.item);
        } else if (_dragOffset != 0) {
          _dragOffset = 0;
          widget.openItemIdNotifier.value = null;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.enableSwipeToDelete)
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
                  color: Colors.grey,
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getItemName(widget.item),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            getItemDescription(widget.item) != null
                                ? (getItemDescription(widget.item)!.length > 30
                                    ? "${getItemDescription(widget.item)!.substring(0, 30)}..."
                                    : getItemDescription(widget.item)!)
                                : "",
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
                      InkWell(
                        onTap: widget.onEditTap,
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Colors.grey,
                          size: 24,
                        ),
                      ),
                      InkWell(
                        onTap: widget.onFavoriteTap,
                        child: Icon(
                          Icons.star,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _formatDate(getItemDate(widget.item)),
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
