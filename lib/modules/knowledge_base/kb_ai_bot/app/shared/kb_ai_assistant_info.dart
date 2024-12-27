import 'package:flutter/material.dart';

class KBAIAssistantInfo extends StatefulWidget {
  final String title;
  final String? initialName;
  final String? initialDescription;
  final Function(String name, String description) onConfirm;

  const KBAIAssistantInfo({
    super.key,
    required this.title,
    this.initialName,
    this.initialDescription,
    required this.onConfirm,
  });

  @override
  State<KBAIAssistantInfo> createState() => _KBAIAssistantInfoState();
}

class _KBAIAssistantInfoState extends State<KBAIAssistantInfo> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName ?? '';
    _descriptionController.text = widget.initialDescription ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Assistant Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Assistant name',
                  border: const OutlineInputBorder(),
                  counterText: '${_nameController.text.length}/50',
                ),
                maxLength: 50,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the assistant name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Assistant Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Assistant description',
                  border: const OutlineInputBorder(),
                  counterText: '${_descriptionController.text.length}/2000',
                ),
                maxLength: 2000,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the assistant description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Cancel Button
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  // Confirm Button
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.onConfirm(
                          _nameController.text,
                          _descriptionController.text,
                        );
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
