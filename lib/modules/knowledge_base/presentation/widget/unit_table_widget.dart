import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/modules/knowledge_base/presentation/controller/knowledge_base_controller.dart';
import 'package:jarvis_ai/modules/knowledge_base/presentation/widget/knowledge_floating_hold_menu.dart';

class UnitTableWidget extends GetWidget<KnowledgeBaseController> {
  const UnitTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //Table view of Knowledge
    return SingleChildScrollView(
      child: DataTable(
          columnSpacing: 20,
          columns: const [
            DataColumn(
                label: Text('Unit',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Source',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Size',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Updated Time',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
          ],
          rows: controller
              .knowledges[controller.selectedKnowledgeIndex.value].units
              .map((unit) {
            return DataRow(
                onSelectChanged: (selected) {
                  if (selected != null && selected) {}
                },
                onLongPress: () {
                  Get.bottomSheet(const KnowledgeFloatingHoldMenu());
                },
                cells: [
                  DataCell(Text(unit.name)),
                  DataCell(Text(
                    unit.source,
                  )),
                  DataCell(Text(
                    unit.getSize().toString(),
                  )),
                  DataCell(Text(
                      "${unit.updatedTime.day}/${unit.updatedTime.month}/${unit.updatedTime.year}"))
                ]);
          }).toList()),
    );
  }
}
