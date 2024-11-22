import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/prompt/data/repository/prompt_repository.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetPromptUsecase extends Usecase {
  final PromptRepository _promptRepository;
  const GetPromptUsecase({required PromptRepository promptRepository})
      : _promptRepository = promptRepository;

  Future<dynamic> run({required Map<String, dynamic> queries}) async {
    return _promptRepository.getPrompt(
      queries: queries,
    );
  }
}
