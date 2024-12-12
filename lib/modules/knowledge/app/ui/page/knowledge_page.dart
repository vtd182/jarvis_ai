import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/locator.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/page/knowledge_view_model.dart';
import 'package:jarvis_ai/modules/knowledge/domain/usecases/get_knowledge_usecase.dart';

class KnowledgePage extends StatelessWidget {
  KnowledgePage({super.key});

  final controller =
      Get.put(KnowledgeViewModel(locator<GetKnowledgeUsecase>()));

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: ListKnowledgeWidget(),
      ),
    );
  }
}

class ListKnowledgeWidget extends StatefulWidget {
  const ListKnowledgeWidget({
    super.key,
  });

  @override
  State<ListKnowledgeWidget> createState() => _ListKnowledgeWidgetState();
}

class _ListKnowledgeWidgetState extends State<ListKnowledgeWidget> {
  @override
  void initState() {
    controller.getAllKnowledge();
    super.initState();
  }

  final controller = Get.find<KnowledgeViewModel>();
  @override
  Widget build(BuildContext context) {
    return Text("Knowledge Page");
  }
}
