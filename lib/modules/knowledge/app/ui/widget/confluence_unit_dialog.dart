import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/page/kl_detail_viewmodel.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/widget/connect_unit_button.dart';
import 'package:jarvis_ai/modules/shared/theme/app_theme.dart';

class ConfluenceUnitDialog extends GetWidget<KlDetailViewModel> {
  ConfluenceUnitDialog({super.key});

  final formKey = GlobalKey<FormState>();
  final nameTextController = TextEditingController();
  final urlTextController = TextEditingController();
  final userNameTextController = TextEditingController();
  final tokenTextController = TextEditingController();

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
                    "Wiki Page URL",
                    style: AppTheme.black_14w600,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: urlTextController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppTheme.grey,
                  filled: true,
                  hintText: "Wiki page url",
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
                    "Confluence Username",
                    style: AppTheme.black_14w600,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: userNameTextController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppTheme.grey,
                  filled: true,
                  hintText: "Username",
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
                    "Confluence Access Token",
                    style: AppTheme.black_14w600,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: tokenTextController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppTheme.grey,
                  filled: true,
                  hintText: "Access token",
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
                  controller.onAddConfluenceUnit(
                    unitName: nameTextController.text.trim(),
                    wikiPageUrl: urlTextController.text.trim(),
                    confluenceUsername: userNameTextController.text.trim(),
                    confluenceAccessToken: tokenTextController.text.trim(),
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
