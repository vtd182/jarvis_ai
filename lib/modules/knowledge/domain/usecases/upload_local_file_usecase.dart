import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_get_unit.dart';
import 'package:suga_core/suga_core.dart';

import '../../data/repository/knowledge_repository.dart';

@lazySingleton
class UploadLocalFileUsecase extends Usecase {
  final KnowledgeRepository _knowledgeRepository;

  const UploadLocalFileUsecase(this._knowledgeRepository);

  Future<ResponseGetUnit> run({required String id, required File file}) async {
    return _knowledgeRepository.uploadLocalFile(id: id, file: file);
  }
}
