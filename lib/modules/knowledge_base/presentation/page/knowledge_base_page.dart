import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/modules/knowledge_base/presentation/controller/knowledge_base_controller.dart';
import 'package:jarvis_ai/modules/knowledge_base/presentation/widget/header_knowledge_widget.dart';
import 'package:jarvis_ai/modules/knowledge_base/presentation/widget/knowledge_table_widget.dart';
import 'package:jarvis_ai/modules/shared/presentation/controller/drawer_controller.dart';
import 'package:jarvis_ai/modules/shared/presentation/widgets/drawerWidget.dart';

class KnowledgeBasePage extends StatelessWidget {
  KnowledgeBasePage({super.key});
  final controller = Get.put(KnowledgeBaseController());
  final AppDrawerController drawerController = Get.put(AppDrawerController());

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: SafeArea(
          child: GestureDetector(
            onTap: () {},
            child: Scaffold(
              key: drawerController.scaffoldKey,

              // Side menu
              drawer: const AppDrawer(),

              body: const Column(
                children: [
                  // Header
                  HeaderKnowledgeWidget(),

                  // Body
                  Expanded(child: KnowledgeTableWidget()),
                ],
              ),
            ),
          ),
        ));
  }
}
