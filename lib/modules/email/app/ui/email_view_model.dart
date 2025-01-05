import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/email/domain/usecase/reply_email.dart';
import 'package:jarvis_ai/modules/email/domain/usecase/suggest_reply_ideas.dart';

import '../../../../core/abstracts/app_view_model.dart';

@lazySingleton
class EmailViewModel extends AppViewModel {
  RxString title = "".obs;
  RxString sender = "".obs;
  RxString content = "".obs;
  RxString reply = "".obs;
  RxString selectedLanguage = "Auto".obs;
  RxString selectedEmailFormality = "Auto".obs;
  RxString selectedEmailTone = "Auto".obs;
  RxString selectedEmailLength = "Medium".obs;
  RxString idea = "Auto".obs;
  final suggestions = <String>[].obs;
  final SuggestReplyIdeasUsecase _suggestReplyIdeasUsecase;
  final ReplyEmailUsecase _replyEmailUsecase;
  RxBool loadingSuggestion = false.obs;
  RxBool loadingReply = false.obs;

  EmailViewModel(this._suggestReplyIdeasUsecase, this._replyEmailUsecase);

  Future<void> responseEmail() async {
    loadingReply.value = true;
    final res = await _replyEmailUsecase.run(email: content.value, mainIdea: idea.value, metadata: {
      'context': [<String, String>{}],
      'subject': title.value != '' ? title.value : 'Auto detect for me',
      'sender': sender.value != '' ? sender.value : 'Auto detect for me',
      'receiver': 'Auto detect for me',
      'style': {
        'length': selectedEmailLength.value,
        'formality': selectedEmailFormality.value,
        'tone': selectedEmailTone.value,
      },
      'language': selectedLanguage.value,
    });
    reply.value = res.email;
    loadingReply.value = false;
  }

  Future<void> generateSuggestions() async {
    loadingSuggestion.value = true;
    final res = await _suggestReplyIdeasUsecase.run(
      email: content.value,
      metadata: {
        'context': [<String, String>{}],
        'subject': title.value != '' ? title.value : 'Auto detect for me',
        'sender': sender.value != '' ? sender.value : 'Auto detect for me',
        'receiver': 'Auto detect for me',
        'language': selectedLanguage.value,
      },
    );
    if (res.ideas.isNotEmpty) {
      suggestions.value = res.ideas;
    }
    loadingSuggestion.value = false;
  }

  final languages = [
    "Auto",
    "Afrikaans",
    "Albanian",
    "Amharic",
    "Arabic",
    "Armenian",
    "Azerbaijani",
    "Basque",
    "Belarusian",
    "Bengali",
    "Bosnian",
    "Bulgarian",
    "Catalan",
    "Cebuano",
    "Chichewa",
    "Chinese (Simplified)",
    "Chinese (Traditional)",
    "Corsican",
    "Croatian",
    "Czech",
    "Danish",
    "Dutch",
    "English",
    "Esperanto",
    "Estonian",
    "Filipino",
    "Finnish",
    "French",
    "Galician",
    "Georgian",
    "German",
    "Greek",
    "Gujarati",
    "Haitian Creole",
    "Hausa",
    "Hawaiian",
    "Hebrew",
    "Hindi",
    "Hmong",
    "Hungarian",
    "Icelandic",
    "Igbo",
    "Indonesian",
    "Irish",
    "Italian",
    "Japanese",
    "Javanese",
    "Kannada",
    "Kazakh",
    "Khmer",
    "Korean",
    "Kurdish (Kurmanji)",
    "Kyrgyz",
    "Lao",
    "Latin",
    "Latvian",
    "Lithuanian",
    "Luxembourgish",
    "Macedonian",
    "Malay",
    "Malayalam",
    "Maltese",
    "Maori",
    "Marathi",
    "Mongolian",
    "Nepali",
    "Norwegian",
    "Pashto",
    "Persian",
    "Polish",
    "Portuguese",
    "Punjabi",
    "Romanian",
    "Russian",
    "Samoan",
    "Scots Gaelic",
    "Serbian",
    "Sesotho",
    "Shona",
    "Sindhi",
    "Sinhala",
    "Slovak",
    "Slovenian",
    "Somali",
    "Spanish",
    "Sundanese",
    "Swahili",
    "Swedish",
    "Tajik",
    "Tamil",
    "Telugu",
    "Thai",
    "Turkish",
    "Ukrainian",
    "Urdu",
    "Uzbek",
    "Vietnamese",
    "Welsh",
    "Xhosa",
    "Yiddish",
    "Yoruba",
    "Zulu"
  ];

  final length = ['Short', 'Medium', 'Long'];

  final formality = [
    'Witty 😄',
    'Direct 🎯',
    'Friendly 🤝',
    'Informational 📘',
    'Confident 💪',
    'Sincere ❤️',
    'Enthusiastic 🎉',
    'Optimistic 🌟',
    'Concerned 🤔',
    'Empathetic 🤗',
  ];

  final tone = [
    'Casual 🕶️',
    'Neutral ⚖️',
    'Formal 👔',
  ];
}
