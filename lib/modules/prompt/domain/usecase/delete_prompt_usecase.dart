

import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/prompt/data/repository/prompt_repository.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class DeletePromptUsecase extends Usecase{
  final PromptRepository _promptRepository;

  const DeletePromptUsecase(this._promptRepository);

  Future<dynamic> run({required String id}) async {
    return _promptRepository.deletePrompt(id: id);
  }
}