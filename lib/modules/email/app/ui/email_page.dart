import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:jarvis_ai/modules/email/app/ui/email_view_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:suga_core/suga_core.dart';
import '../../../../locator.dart';
import 'dart:async';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends BaseViewState<EmailPage, EmailViewModel> {
  @override
  EmailViewModel createViewModel() {
    return locator<EmailViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        EmailInput(),
        const Divider(),
        Expanded(child: ReplySuggestions()),
      ],
    ));
  }
}

class EmailInput extends StatelessWidget {
  EmailInput({super.key});
  final _debouncer = Debouncer(milliseconds: 1000);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                decoration: InputDecoration(
                  hintText: 'Email title...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (value) {
                  locator<EmailViewModel>().title.value = value;
                  if (locator<EmailViewModel>().content.value.isNotEmpty) {
                    _debouncer.run(() => locator<EmailViewModel>().generateSuggestions());
                  }
                }),
            const SizedBox(height: 16),
            TextField(
                decoration: InputDecoration(
                  hintText: 'From: ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (value) {
                  locator<EmailViewModel>().sender.value = value;
                  if (locator<EmailViewModel>().content.value.isNotEmpty) {
                    _debouncer.run(() => locator<EmailViewModel>().generateSuggestions());
                  }
                }),
            const SizedBox(height: 16),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Email content...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                locator<EmailViewModel>().content.value = value;
                if (value.isNotEmpty) {
                  _debouncer.run(() => locator<EmailViewModel>().generateSuggestions());
                }
              },
            ),
          ],
        ));
  }
}

class ReplySuggestions extends StatelessWidget {
  ReplySuggestions({super.key});
  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            final emailViewModel = locator<EmailViewModel>();

            if (emailViewModel.loadingSuggestion.value) {
              return Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.blueAccent,
                  size: 40,
                ),
              );
            }

            return Obx(() => ListView.builder(
                  itemCount: emailViewModel.suggestions.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        emailViewModel.idea.value = emailViewModel.suggestions[index];
                        textEditingController.text = emailViewModel.suggestions[index];
                      },
                      child: Obx(() => _buildReplyOption(
                            emailViewModel.suggestions[index],
                            emailViewModel.idea.value == emailViewModel.suggestions[index],
                          )),
                    );
                  },
                ));
          }),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => _showEmailStyleDialog(context),
                child: const Text('Style & Length'),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () => _showLanguageChooser(context),
                child: Obx(
                  () => Text('Language: ${locator<EmailViewModel>().selectedLanguage.value}'),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Tell Jarvis how you want to reply...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (value) {
                      locator<EmailViewModel>().idea.value = value;
                    }),
                //change when idea.value change
              ),
              const SizedBox(width: 16),
              GestureDetector(
                  onTap: () => _showEmailRespondDialog(context),
                  child: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.send),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReplyOption(String text, bool selected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: selected ? Colors.blue.shade50 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: ListTile(
          title: Text(text),
          trailing: selected ? const Icon(Icons.check) : const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }

  void _showLanguageChooser(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LanguageDial(
              languages: locator<EmailViewModel>().languages,
              onLanguageSelected: (selectedLanguage) {
                // print('Selected Language: $selectedLanguage');
                locator<EmailViewModel>().selectedLanguage.value = selectedLanguage;
                // Handle language selection
              },
            ),
          ),
        );
      },
    );
  }

  void _showEmailRespondDialog(BuildContext context) {
    locator<EmailViewModel>().responseEmail();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Email Respond",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Obx(() {
                  if (locator<EmailViewModel>().loadingReply.value) {
                    return Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.blueAccent,
                        size: 60,
                      ),
                    );
                  } else {
                    return Column(children: [
                      Obx(() => Text(locator<EmailViewModel>().reply.value)),
                      Center(
                          child: ElevatedButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: locator<EmailViewModel>().reply.value));
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
                              },
                              child: const Text('Copy')))
                    ]);
                  }
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEmailStyleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Email Style', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                const Text('Length'),
                Wrap(
                  spacing: 10,
                  children: [
                    for (var length in locator<EmailViewModel>().length) _buildOptionChip(length, 'Length'),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Formality'),
                Wrap(spacing: 10, children: [
                  for (var formality in locator<EmailViewModel>().formality) _buildOptionChip(formality, 'Formality'),
                ]),
                const SizedBox(height: 20),
                const Text('Tone'),
                Wrap(
                  spacing: 10,
                  children: [
                    for (var tone in locator<EmailViewModel>().tone) _buildOptionChip(tone, 'Tone'),
                  ],
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionChip(String value, String type) {
    return Obx(() => ChoiceChip(
          label: Text(value),
          selected: (type == 'Length' && locator<EmailViewModel>().selectedEmailLength.value == value) ||
              (type == 'Formality' && locator<EmailViewModel>().selectedEmailFormality.value == value) ||
              (type == 'Tone' && locator<EmailViewModel>().selectedEmailTone.value == value),
          onSelected: (selected) {
            switch (type) {
              case 'Length':
                locator<EmailViewModel>().selectedEmailLength.value = value;
                break;
              case 'Formality':
                locator<EmailViewModel>().selectedEmailFormality.value = value;
                break;
              case 'Tone':
                locator<EmailViewModel>().selectedEmailTone.value = value;
                break;
            }
          },
        ));
  }
}

class LanguageDial extends StatefulWidget {
  final List<String> languages;
  final ValueChanged<String> onLanguageSelected;

  const LanguageDial({
    super.key,
    required this.languages,
    required this.onLanguageSelected,
  });

  @override
  _LanguageDialState createState() => _LanguageDialState();
}

class _LanguageDialState extends State<LanguageDial> {
  int _selectedIndex = 0;

  @override
  initState() {
    super.initState();
    _selectedIndex = widget.languages.indexOf(locator<EmailViewModel>().selectedLanguage.value);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250, // Dial height
      child: Column(
        children: [
          const Text(
            'Language',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListWheelScrollView.useDelegate(
              physics: const FixedExtentScrollPhysics(),
              controller: FixedExtentScrollController(initialItem: _selectedIndex),
              itemExtent: 50,
              diameterRatio: 2.0, // Adjust to control curvature
              perspective: 0.003, // Adjust to control 3D effect
              onSelectedItemChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                // widget.onLanguageSelected(widget.languages[index]);
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  return Center(
                    child: Text(
                      widget.languages[index],
                      style: TextStyle(
                        fontSize: 16,
                        color: index == _selectedIndex ? Colors.blue : Colors.black54,
                        fontWeight: index == _selectedIndex ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                },
                childCount: widget.languages.length,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              widget.onLanguageSelected(widget.languages[_selectedIndex]);
              Navigator.pop(context, widget.languages[_selectedIndex]);
            },
            child: const Text('Select'),
          ),
        ],
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
