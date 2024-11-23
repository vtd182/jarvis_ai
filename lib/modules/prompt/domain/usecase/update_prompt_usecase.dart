import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/prompt/data/repository/prompt_repository.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class UpdatePromptUsecase extends Usecase {
  final PromptRepository _promptRepository;
  const UpdatePromptUsecase({required PromptRepository promptRepository}) : _promptRepository = promptRepository;

  Future<dynamic> run(
      {required String id,
      required String category,
      String? content,
      required String description,
      required bool isPublic,
      required String language,
      String? title}) async {
    return _promptRepository.updatePrompt(
      id: id,
      category: category,
      content: content,
      description: description,
      isPublic: isPublic,
      language: language,
      title: title,
    );
  }
}
