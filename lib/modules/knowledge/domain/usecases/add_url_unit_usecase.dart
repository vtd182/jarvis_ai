import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge/data/repository/knowledge_repository.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/request_add_url.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_get_unit.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class AddUrlUnitUsecase extends Usecase {
  final KnowledgeRepository _knowledgeRepository;

  const AddUrlUnitUsecase(this._knowledgeRepository);

  Future<ResponseGetUnit> run(
      {required String id, required RequestAddUrl body}) async {
    return _knowledgeRepository.addWebUnit(id: id, body: body);
  }
}
