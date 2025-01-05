import 'package:flutter/material.dart';
import 'package:jarvis_ai/gen/assets.gen.dart';

class KnowledgeBaseEmptyImport extends StatelessWidget {
  VoidCallback onImport;
  KnowledgeBaseEmptyImport({
    super.key,
    required this.onImport,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Assets.images.imgImportKnowledge.image(
          width: 100,
          height: 100,
        ),
        const SizedBox(height: 16),
        const Text(
          'No knowledge base found',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onImport,
          child: const Text('Import knowledge base'),
        ),
      ],
    );
  }
}
