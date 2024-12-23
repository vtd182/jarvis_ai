import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge/data/data_source/service/knowledge_service.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/request_add_confluence.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/request_add_slack.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/request_add_url.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/request_create_kl.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/request_knowledge_model.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_create_kl.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_get_list_kl.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_get_list_unit.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_get_unit.dart';

@lazySingleton
class KnowledgeRepository {
  final KnowledgeService _knowledgeService;

  KnowledgeRepository(this._knowledgeService);

  Future<ResponseGetListKl> getKnowledge(
      {required RequestKnowledgeModel queries}) async {
    return _knowledgeService.getKnowledge(queries);
  }

  Future<ResponseCreateKl> createKnowledge(
      {required RequestCreateKl body}) async {
    return _knowledgeService.createKnowledge(body);
  }

  Future<ResponseGetListUnit> getUnitsOfKnowledge(
      {required String id, required RequestKnowledgeModel queries}) async {
    return _knowledgeService.getUnitsOfKnowledge(id, queries);
  }

  Future<ResponseGetUnit> uploadLocalFile(
      {required String id, required File file}) async {
    return _knowledgeService.uploadLocalFile(id, file);
  }

  Future<ResponseGetUnit> addWebUnit(
      {required String id, required RequestAddUrl body}) async {
    return _knowledgeService.addWebUnit(id, body);
  }

  Future<ResponseGetUnit> addSlackUnit(
      {required String id, required RequestAddSlack body}) async {
    return _knowledgeService.addSlackUnit(id, body);
  }

  Future<ResponseGetUnit> addConfluenceUnit(
      {required String id, required RequestAddConfluence body}) async {
    return _knowledgeService.addConfluenceUnit(id, body);
  }

  Future<void> deleteKnowledge({required String id}) async {
    return _knowledgeService.deleteKnowledge(id);
  }

  Future<ResponseGetUnit> updateStatusUnit({
    required String id,
    required Map<String, dynamic> body,
  }) async {
    return _knowledgeService.updateStatusUnit(id, body);
  }

  Future<void> deleteUnitById(
      {required String idKl, required String idUnit}) async {
    return _knowledgeService.deleteUnitById(idKl, idUnit);
  }
}
