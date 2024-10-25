import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/modules/knowledge_base/presentation/controller/knowledge_base_controller.dart';
import 'package:jarvis_ai/modules/knowledge_base/presentation/widget/knowledge_floating_hold_menu.dart';

class KnowledgeTableWidget extends GetWidget<KnowledgeBaseController> {
  const KnowledgeTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //Table view of Knowledge
    return SingleChildScrollView(
      child: DataTable(
          showCheckboxColumn: false,
          columnSpacing: 20,
          columns: const [
            DataColumn(label: Text('Knowledge', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Units', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Size', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Updated Time', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
          ],
          rows: controller.knowledges.map((knowledge) {
            return DataRow(
                onSelectChanged: (selected) {
                  if (selected != null && selected) {
                    Get.toNamed("/knowledgeDetail");
                  }
                },
                onLongPress: () {
                  Get.bottomSheet(const KnowledgeFloatingHoldMenu());
                },
                cells: [
                  DataCell(Text(knowledge.name)),
                  DataCell(Text(
                    knowledge.units.length.toString(),
                  )),
                  DataCell(Text(
                    knowledge.getSize().toString(),
                  )),
                  DataCell(Text("${knowledge.updatedTime.day}/${knowledge.updatedTime.month}/${knowledge.updatedTime.year}"))
                ]);
          }).toList()),
    );
  }
}
