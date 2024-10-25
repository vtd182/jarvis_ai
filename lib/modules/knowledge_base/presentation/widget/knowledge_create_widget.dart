import 'package:flutter/material.dart';

class KnowledgeCreateWidget extends StatelessWidget {
  const KnowledgeCreateWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        child: Column(
          children: [
            // Bot
            Column(children: [
              const Text('Create Knowledge Base', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const TextField(decoration: InputDecoration(labelText: 'Name', border: OutlineInputBorder(), hintText: 'Enter knowledge base name')),
              const SizedBox(height: 20),
              const TextField(decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder(), hintText: 'Enter description')),
              const SizedBox(height: 20),
              //Ok button
              ElevatedButton(
                onPressed: () {},
                child: const Text('Create'),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
