import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:injectable/injectable.dart';
import 'package:jarvis_ai/config/config.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/request_add_confluence.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/request_add_slack.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/request_add_url.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/request_create_kl.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/request_knowledge_model.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_create_kl.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_get_kl.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_get_list_kl.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_get_list_unit.dart';
import 'package:jarvis_ai/modules/knowledge/domain/models/response_get_unit.dart';
import 'package:retrofit/retrofit.dart';

part 'knowledge_service.g.dart';

@lazySingleton
@RestApi(
    baseUrl:
        "${Config.knowledgeBaseUrl}/kb-core/v${Config.apiVersion}/knowledge")
abstract class KnowledgeService {
  @factoryMethod
  factory KnowledgeService(Dio dio) = _KnowledgeService;

  @GET("")
  Future<ResponseGetListKl> getKnowledge(
      @Queries() RequestKnowledgeModel queries);

  @POST("")
  Future<ResponseCreateKl> createKnowledge(@Body() RequestCreateKl body);

  @GET("/{id}/units")
  Future<ResponseGetListUnit> getUnitsOfKnowledge(
      @Path("id") String id, @Queries() RequestKnowledgeModel queries);

  @MultiPart()
  @POST("/{id}/local-file")
  Future<ResponseGetUnit> uploadLocalFile(
    @Path("id") String id,
    @Part(name: "file") File file,
  );

  @POST("/{id}/web")
  Future<ResponseGetUnit> addWebUnit(
    @Path("id") String id,
    @Body() RequestAddUrl body,
  );

  @POST("/{id}/slack")
  Future<ResponseGetUnit> addSlackUnit(
    @Path("id") String id,
    @Body() RequestAddSlack body,
  );

  @POST("/{id}/confluence")
  Future<ResponseGetUnit> addConfluenceUnit(
    @Path("id") String id,
    @Body() RequestAddConfluence body,
  );

  @DELETE("/{id}")
  Future<void> deleteKnowledge(@Path("id") String id);

  @PATCH("/units/{id}/status")
  Future<ResponseGetUnit> updateStatusUnit(
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE("/{idKl}/units/{idUnit}")
  Future<void> deleteUnitById(
    @Path("idKl") String idKl,
    @Path("idUnit") String idUnit,
  );
}
