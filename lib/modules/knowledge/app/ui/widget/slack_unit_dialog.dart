import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/page/kl_detail_viewmodel.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/widget/connect_unit_button.dart';
import 'package:jarvis_ai/modules/shared/theme/app_theme.dart';

class SlackUnitDialog extends GetWidget<KlDetailViewModel> {
  SlackUnitDialog({super.key});

  final formKey = GlobalKey<FormState>();
  final nameTextController = TextEditingController();
  final workspaceTextController = TextEditingController();
  final botTokenTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    "*",
                    style: AppTheme.red_14w600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Name",
                    style: AppTheme.black_14w600,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: nameTextController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppTheme.grey,
                  filled: true,
                  hintText: "Name of unit knowledge",
                  hintStyle: AppTheme.grey1_14w400,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                textAlignVertical: TextAlignVertical.top,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    "*",
                    style: AppTheme.red_14w600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Slack Workspace",
                    style: AppTheme.black_14w600,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: workspaceTextController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppTheme.grey,
                  filled: true,
                  hintText: "Workspace",
                  hintStyle: AppTheme.grey1_14w400,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                textAlignVertical: TextAlignVertical.top,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required";
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Text(
                    "*",
                    style: AppTheme.red_14w600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Slack Bot Token",
                    style: AppTheme.black_14w600,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: botTokenTextController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppTheme.grey,
                  filled: true,
                  hintText: "Bot Token",
                  hintStyle: AppTheme.grey1_14w400,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                textAlignVertical: TextAlignVertical.top,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              ConnectUnitButton(onConnect: () {
                if (formKey.currentState!.validate()) {
                  controller.onAddSlackUnit(
                    unitName: nameTextController.text.trim(),
                    slackWorkspace: workspaceTextController.text.trim(),
                    slackBotToken: botTokenTextController.text.trim(),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
