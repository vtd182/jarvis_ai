import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/modules/knowledge/app/ui/page/knowledge_view_model.dart';
import 'package:jarvis_ai/modules/shared/theme/app_theme.dart';

class CreateKlDialog extends GetWidget<KnowledgeViewModel> {
  CreateKlDialog({super.key});

  final nameTextController = TextEditingController();
  final desTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();

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
              Text(
                "Knowledge Name",
                style: AppTheme.black_14w600,
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
                  hintText: "Name",
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
              Text(
                "Description",
                style: AppTheme.black_14w600,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: desTextController,
                maxLines: 4,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppTheme.grey,
                  filled: true,
                  hintMaxLines: 2,
                  hintText: "Description of the knowledge",
                  hintStyle: AppTheme.grey1_14w400,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                textAlignVertical: TextAlignVertical.top,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: AppTheme.black_14w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: controller.isLoading.value
                        ? null
                        : () {
                            if (formKey.currentState!.validate()) {
                              controller.onCreateKl(nameTextController.text,
                                  desTextController.text);
                            }
                          },
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: AppTheme.primaryLinearGradient),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Obx(
                        () => controller.isLoading.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white),
                              )
                            : Text(
                                "Create",
                                style: AppTheme.white_14w600,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
