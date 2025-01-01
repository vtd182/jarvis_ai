import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge/data/repository/knowledge_repository.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/request_create_kl.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_create_kl.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class CreateKlUsecase extends Usecase {
  final KnowledgeRepository _knowledgeRepository;
  const CreateKlUsecase({required KnowledgeRepository knowledgeRepository})
      : _knowledgeRepository = knowledgeRepository;

  Future<ResponseCreateKl> run({required RequestCreateKl body}) async {
    return _knowledgeRepository.createKnowledge(
      body: body,
    );
  }
}
