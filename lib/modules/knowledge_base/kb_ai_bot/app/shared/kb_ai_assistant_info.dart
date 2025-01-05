import 'package:flutter/material.dart';

class KBAIAssistantInfo extends StatefulWidget {
  final String title;
  final String? initialName;
  final String? initialDescription;
  final String? initialInstructions;
  final bool isInstructionsUpdate;
  final Function(String name, String description, String instruction) onConfirm;

  const KBAIAssistantInfo({
    super.key,
    required this.title,
    this.initialName,
    this.initialDescription,
    required this.onConfirm,
    this.initialInstructions,
    this.isInstructionsUpdate = false,
  });

  @override
  State<KBAIAssistantInfo> createState() => _KBAIAssistantInfoState();
}

class _KBAIAssistantInfoState extends State<KBAIAssistantInfo> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName ?? '';
    _descriptionController.text = widget.initialDescription ?? '';
    _instructionsController.text = widget.initialInstructions ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
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
        ),
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
                if (!widget.isInstructionsUpdate) const SizedBox(height: 16),
                // Assistant Name Field
                if (!widget.isInstructionsUpdate)
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
                if (!widget.isInstructionsUpdate) const SizedBox(height: 16),
                // Assistant Description Field
                if (!widget.isInstructionsUpdate)
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Assistant description',
                      border: const OutlineInputBorder(),
                      counterText: '${_descriptionController.text.length}/2000',
                    ),
                    maxLength: 2000,
                    maxLines: 4,
                  ),
                if (widget.isInstructionsUpdate) const SizedBox(height: 16),
                // Assistant Description Field
                if (widget.isInstructionsUpdate)
                  TextFormField(
                    controller: _instructionsController,
                    decoration: InputDecoration(
                      labelText: 'Assistant Instructions',
                      border: const OutlineInputBorder(),
                      counterText: '${_instructionsController.text.length}/2000',
                    ),
                    maxLength: 2000,
                    maxLines: 4,
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
                            _instructionsController.text,
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1677FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
