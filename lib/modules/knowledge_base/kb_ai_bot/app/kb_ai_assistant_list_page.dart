import 'package:flutter/material.dart';
import 'package:jarvis_ai/locator.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/app/kb_ai_assistant_list_page_viewmodel.dart';
import 'package:suga_core/suga_core.dart';

class KBAIAssistantListPage extends StatefulWidget {
  const KBAIAssistantListPage({super.key});

  @override
  State<KBAIAssistantListPage> createState() => _KBAIAssistantListPageState();
}

class _KBAIAssistantListPageState extends BaseViewState<KBAIAssistantListPage, KBAIAssistantListPageViewModel> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  @override
  KBAIAssistantListPageViewModel createViewModel() {
    return locator<KBAIAssistantListPageViewModel>();
  }
}
