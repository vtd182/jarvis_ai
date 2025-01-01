import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge/data/repository/knowledge_repository.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/request_add_confluence.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_get_unit.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class AddConfluenceUnitUsecase extends Usecase {
  final KnowledgeRepository _knowledgeRepository;

  const AddConfluenceUnitUsecase(this._knowledgeRepository);

  Future<ResponseGetUnit> run({required String id, required RequestAddConfluence body}) async {
    return _knowledgeRepository.addConfluenceUnit(id: id, body: body);
  }
}
