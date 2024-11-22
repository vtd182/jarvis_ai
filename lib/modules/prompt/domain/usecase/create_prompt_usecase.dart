import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/prompt/data/repository/prompt_repository.dart';
import 'package:suga_core/suga_core.dart';


@lazySingleton
class CreatePromptUsecase extends Usecase {
  final PromptRepository _promptRepository;
  const CreatePromptUsecase({required PromptRepository promptRepository})
      : _promptRepository = promptRepository;

  Future<dynamic> run(
      {required String category,
      required String content,
      required String description,
      required bool isPublic,
      required String language,
      required String title}) async {
    return _promptRepository.createPrompt(
      category: category,
      content: content,
      description: description,
      isPublic: isPublic,
      language: language,
      title: title,
    );
  }
}
