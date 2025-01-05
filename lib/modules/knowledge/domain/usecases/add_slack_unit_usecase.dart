import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge/data/repository/knowledge_repository.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/request_add_slack.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_get_unit.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class AddSlackUnitUsecase extends Usecase {
  final KnowledgeRepository _knowledgeRepository;

  const AddSlackUnitUsecase(this._knowledgeRepository);

  Future<ResponseGetUnit> run({required String id, required RequestAddSlack body}) async {
    return _knowledgeRepository.addSlackUnit(id: id, body: body);
  }
}
