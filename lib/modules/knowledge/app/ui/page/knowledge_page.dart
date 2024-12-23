import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/locator.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/page/knowledge_view_model.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/widget/list_kl_widget.dart';
import 'package:jarvis_ai/modules/knowledge/domain/usecases/create_kl_usecase.dart';
import 'package:jarvis_ai/modules/knowledge/domain/usecases/delete_kl_usecase.dart';
import 'package:jarvis_ai/modules/knowledge/domain/usecases/get_knowledge_usecase.dart';

class KnowledgePage extends StatelessWidget {
  KnowledgePage({super.key});

  final controller = Get.put(
    KnowledgeViewModel(
      locator<GetKnowledgeUsecase>(),
      locator<CreateKlUsecase>(),
      locator<DeleteKnowledgeUsecase>(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: ListKlWidget(),
      ),
    );
  }
}
