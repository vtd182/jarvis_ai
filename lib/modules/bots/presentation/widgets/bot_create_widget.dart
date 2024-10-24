import 'package:flutter/material.dart';

class BotsCreateWidget extends StatelessWidget {
  const BotsCreateWidget({super.key});
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
              const Text('Create Bot', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const TextField(decoration: InputDecoration(labelText: 'Bot Name', border: OutlineInputBorder(), hintText: 'Enter bot name')),
              const SizedBox(height: 20),
              const TextField(
                  decoration: InputDecoration(labelText: 'Bot Description', border: OutlineInputBorder(), hintText: 'Enter bot description')),
              const SizedBox(height: 20),
              const TextField(decoration: InputDecoration(labelText: 'Bot Image', border: OutlineInputBorder(), hintText: 'Enter bot image')),
              const SizedBox(height: 20),
              const TextField(decoration: InputDecoration(labelText: 'Bot prompt', border: OutlineInputBorder(), hintText: 'Enter bot prompt')),
              const SizedBox(height: 20),
              //Ok button
              ElevatedButton(
                onPressed: () {},
                child: const Text('Create Bot'),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
