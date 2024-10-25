import 'package:flutter/material.dart';

class UnitCreateWidget extends StatelessWidget {
  const UnitCreateWidget({super.key});
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
              const Text('Add Unit',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              // List of unit types to choose from (localFile, googleDrive, dropbox, etc)
              // Build rows of unit types to choose from
              // For each unit type, show an icon and a text description
              // When a unit type is selected, show a checkmark next to it
              // When the user clicks on a unit type, show a dialog to add the unit
              // The dialog should have a text field for the name of the unit
              // Implementation:
              SingleChildScrollView(
                  child: Column(
                      children: const [
                "Local File",
                "Website",
                "Github Repositories",
                "Gitlab Repositories",
                "Google Drive",
                "Slack",
                "Confluence"
              ].map((name) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                    const Icon(Icons.check_circle, color: Colors.grey),
                      const SizedBox(width: 10),
                    Text(name, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 20),
                                        
                    ],
                  ),
                );
                             
              }).toList())),

              //Ok button
              ElevatedButton(
                onPressed: () {},
                child: const Text('Add unit'),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
